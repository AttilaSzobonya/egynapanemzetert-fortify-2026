#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${REPO_ROOT}/common.sh"

podman_dev_defaults
podman_dev_build_image
podman_dev_ensure_volumes
podman_dev_npm_dev_server_cmd
podman_dev_run_base_args

podman_dev_remove_container

podman run -d \
  "${PODMAN_RUN_BASE_ARGS[@]}" \
  "${IMAGE}" \
  "${DEV_SERVER_CMD[@]}" >/dev/null

echo "Started container ${CONTAINER_NAME} (port ${PORT})."
