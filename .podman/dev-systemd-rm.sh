#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/common.sh"

SCOPE="${SYSTEMD_SCOPE:-user}" # user | system

if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl not found; cannot remove a systemd unit." >&2
  exit 1
fi

podman_dev_defaults

unit_base="${CONTAINER_NAME}"
quadlet_file="${unit_base}.container"
service_unit="${unit_base}.service"

# Legacy unit name from deprecated `podman generate systemd` flow.
legacy_service_unit="container-${CONTAINER_NAME}.service"

if [[ "${SCOPE}" == "system" ]]; then
  quadlet_dir="/etc/containers/systemd"
  systemctl_cmd=(sudo systemctl)
  legacy_unit_path="/etc/systemd/system/${legacy_service_unit}"
else
  quadlet_dir="${XDG_CONFIG_HOME:-${HOME}/.config}/containers/systemd"
  systemctl_cmd=(systemctl --user)
  legacy_unit_path="${HOME}/.config/systemd/user/${legacy_service_unit}"
fi

quadlet_path="${quadlet_dir}/${quadlet_file}"

"${systemctl_cmd[@]}" stop "${service_unit}" >/dev/null 2>&1 || true
"${systemctl_cmd[@]}" disable "${service_unit}" >/dev/null 2>&1 || true
"${systemctl_cmd[@]}" stop "${legacy_service_unit}" >/dev/null 2>&1 || true
"${systemctl_cmd[@]}" disable "${legacy_service_unit}" >/dev/null 2>&1 || true

if [[ "${SCOPE}" == "system" ]]; then
  sudo rm -f "${quadlet_path}" "${legacy_unit_path}"
  sudo systemctl daemon-reload
else
  rm -f "${quadlet_path}" "${legacy_unit_path}"
  systemctl --user daemon-reload
fi

# Remove the container too (service would recreate it anyway).
podman rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true

echo "Removed systemd service and quadlet for ${CONTAINER_NAME} (${SCOPE} scope)."
