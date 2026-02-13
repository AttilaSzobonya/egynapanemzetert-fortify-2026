#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${REPO_ROOT}/common.sh"

SCOPE="${SYSTEMD_SCOPE:-user}" # user | system

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not found; cannot install a systemd unit." >&2
  exit 1
fi

podman_dev_defaults
podman_dev_build_image
podman_dev_ensure_volumes
podman_dev_npm_dev_server_cmd
podman_dev_run_base_args

podman_dev_remove_container

# Use Podman Quadlet (.container) files instead of `podman generate systemd` (deprecated).
unit_base="${CONTAINER_NAME}"
quadlet_file="${unit_base}.container"
service_unit="${unit_base}.service"

if [[ "${SCOPE}" == "system" ]]; then
  quadlet_dir="/etc/containers/systemd"
  install_target="${quadlet_dir}/${quadlet_file}"
  wanted_by="multi-user.target"
else
  quadlet_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/containers/systemd"
  install_target="${quadlet_dir}/${quadlet_file}"
  wanted_by="default.target"
fi

mkdir -p "${quadlet_dir}"

tmpfile="$(mktemp)"
cleanup() { rm -f "${tmpfile}"; }
trap cleanup EXIT

cat >"${tmpfile}" <<EOF
[Unit]
Description=Dev server (${unit_base})

[Container]
Image=${IMAGE}
ContainerName=${CONTAINER_NAME}
UserNS=keep-id
PublishPort=${PORT}:1313
Volume=${REPO_ROOT}:/project:Z
WorkingDir=/project
Environment=HUGO_CACHEDIR=/tmp/hugo_cache
Exec=/bin/sh -lc "${DEV_SERVER_SHELL_CMD}"

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=${wanted_by}
EOF

if [[ "${SCOPE}" == "system" ]]; then
  sudo install -m 0644 "${tmpfile}" "${install_target}"
  sudo systemctl daemon-reload
  sudo systemctl enable --now "${service_unit}" || sudo systemctl start "${service_unit}"
  echo "Installed and started system Quadlet service: ${service_unit}"
else
  install -m 0644 "${tmpfile}" "${install_target}"
  systemctl --user daemon-reload
  systemctl --user enable --now "${service_unit}" || systemctl --user start "${service_unit}"
  echo "Installed and started user Quadlet service: ${service_unit}"
  echo "This will auto-start on login (no linger required)."
fi
