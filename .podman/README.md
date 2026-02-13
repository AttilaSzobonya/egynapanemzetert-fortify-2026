# Podman dev scripts

This folder contains Podman helpers for running the Hugo dev server inside a container.

The scripts build a local dev image and run `npm run dev` (which executes `hugo server`) against the [egynapanemzetert_2026/](../egynapanemzetert_2026/) content.

## What’s here

- [podman/Containerfile.dev](Containerfile.dev)
  - Development image definition.
  - Base image is `node:24-alpine`; Hugo is installed via `apk` and Go is installed from go.dev.

- [podman/common.sh](common.sh)
  - Shared defaults and helpers (image tag, port, container name, base `podman run` args).

- [podman/dev-it.sh](dev-it.sh)
  - Builds the dev image and runs the dev server in an interactive terminal (`--rm -it`).

- [podman/dev-d.sh](dev-d.sh)
  - Builds the dev image and runs the dev server detached (`-d`).

- [podman/dev-systemd.sh](dev-systemd.sh)
  - Installs a systemd Quadlet `.container` unit and starts it (user scope by default).

- [podman/dev-systemd-rm.sh](dev-systemd-rm.sh)
  - Removes the Quadlet unit (and a legacy generated unit if present) and deletes the container.

## Defaults and configuration

All scripts share these environment variables:

- `HUGO_PORT` (default: `1313`)
  - Host port published to container port `1313`.

- `HUGO_IMAGE` (default: `hugo-dev:nodejs`)
  - Local image tag to build/use.

- `HUGO_CONTAINER_NAME` (default: `egynapanemzetert-hugo-dev`)
  - Container name (and also the base name for the Quadlet unit).

- `SYSTEMD_SCOPE` (default: `user`, allowed: `user` or `system`)
  - Only used by [podman/dev-systemd.sh](dev-systemd.sh) and [podman/dev-systemd-rm.sh](dev-systemd-rm.sh).

## Typical usage

Run these from the repo root.

### Interactive dev server

```sh
./.podman/dev-it.sh
```

Open http://localhost:1313

Change the host port:

```sh
HUGO_PORT=8080 ./.podman/dev-it.sh
```

### Detached container

```sh
./.podman/dev-d.sh
podman ps
podman logs -f egynapanemzetert-hugo-dev
```

Stop/remove it:

```sh
podman rm -f egynapanemzetert-hugo-dev
```

### systemd (Quadlet)

User service (auto-start on login):

```sh
./.podman/dev-systemd.sh
systemctl --user status egynapanemzetert-hugo-dev.service
journalctl --user -u egynapanemzetert-hugo-dev.service -f
```

System service (boot-time service; requires sudo):

```sh
SYSTEMD_SCOPE=system ./.podman/dev-systemd.sh
sudo systemctl status egynapanemzetert-hugo-dev.service
```

Remove the service:

```sh
./.podman/dev-systemd-rm.sh
```

## What the container runs

The scripts run Hugo via:

- `npm run project-setup` (idempotent)
- `npm run dev -- --bind 0.0.0.0 --port 1313`

The extra `--bind 0.0.0.0` is so the Hugo server is reachable from outside the container.

The repo root is mounted into the container at `/project`.

## Where the systemd unit lives

[podman/dev-systemd.sh](dev-systemd.sh) writes a Quadlet `.container` file named after the container:

- User scope: `~/.config/containers/systemd/egynapanemzetert-hugo-dev.container` (or `$XDG_CONFIG_HOME/containers/systemd/...`)
- System scope: `/etc/containers/systemd/egynapanemzetert-hugo-dev.container`

systemd then exposes it as:

- `egynapanemzetert-hugo-dev.service`

## Changing tool versions

Edit [podman/Containerfile.dev](Containerfile.dev):

- **Node version:** change the `FROM node:...` line.
- **Go version:** change `ARG GO_VERSION=...`.
- **Hugo version:** currently installed via `apk add hugo` from Alpine edge/community. To pin a specific Hugo version, you’ll need to adjust the APK repository/version pinning logic in the Containerfile.

Then rerun any script (they rebuild the image each time):

```sh
./.podman/dev-it.sh
```

## Troubleshooting

- Port already in use: run with a different `HUGO_PORT`.
- Quadlet service won’t start: check logs via `journalctl --user -u egynapanemzetert-hugo-dev.service -f` (or system scope with `sudo journalctl -u ... -f`).
- Permissions/SELinux issues on the bind mount: the scripts mount the repo as `...:/project:Z` and use `--userns=keep-id`.
