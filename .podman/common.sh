#!/usr/bin/env bash

podman_dev_repo_root() {
  cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd
}

podman_dev_defaults() {
  REPO_ROOT="$(podman_dev_repo_root)"
  IMAGE="${HUGO_IMAGE:-hugo-dev:nodejs}"
  PORT="${HUGO_PORT:-1313}"
  CONTAINER_NAME="${HUGO_CONTAINER_NAME:-egynapanemzetert-hugo-dev}"
}

podman_dev_build_image() {
  podman build -f "${REPO_ROOT}/.podman/Containerfile.dev" -t "${IMAGE}" "${REPO_ROOT}"
}

podman_dev_ensure_volumes() {
  podman volume inspect hugo_cache >/dev/null 2>&1 || podman volume create hugo_cache >/dev/null
  podman volume inspect go_mod_cache >/dev/null 2>&1 || podman volume create go_mod_cache >/dev/null
}

podman_dev_remove_container() {
  podman rm -f "${CONTAINER_NAME}" 2>/dev/null || true
}

podman_dev_npm_dev_server_cmd() {
  # Keep the container port stable (1313) so host port remapping via $PORT
  # continues to work (PublishPort=$PORT:1313).
  DEV_SERVER_SHELL_CMD='set -eu; cd /project; if [ ! -d node_modules ]; then echo node_modules missing: installing...; if [ -f package-lock.json ]; then npm ci; else npm install; fi; fi; npm run project-setup; exec npm run dev -- --bind 0.0.0.0 --port 1313'
  DEV_SERVER_CMD=(/bin/sh -lc "${DEV_SERVER_SHELL_CMD}")
}

podman_dev_run_base_args() {
  PODMAN_RUN_BASE_ARGS=(
    --userns=keep-id
    --name "${CONTAINER_NAME}"
    -p "${PORT}:1313"
    -v "${REPO_ROOT}:/project:Z"
    -e HUGO_CACHEDIR=/tmp/hugo_cache
  )
}
