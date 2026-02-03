# App template (behind edge)
This template shows how to run a Docker Compose application without publishing ports to the public internet.

## Concept
- Edge (Caddy) listens on 80/443 on the host.
- Apps attach to the shared docker network `edge` and are reachable by edge reverse proxy via internal DNS (service/container name).

## Steps for a new application
1) Copy this template into `ops/vps/apps/<app-name>/`.
2) Deploy to the VPS at `/opt/apps/<app-name>` (e.g. via `scripts/deploy-vps.ps1`).
3) Add a `reverse_proxy` rule to `ops/vps/edge/Caddyfile`.
4) Apply edge changes (Caddyfile is bind-mounted; Caddy does NOT auto-reload on file changes):
   - `cd /opt/t1/edge && docker compose up -d`
   - `docker exec t1-edge-caddy caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile`

## reverse_proxy example
If your compose project is `myapp`, the service is `app`, and it listens on 80, then in Caddyfile:
- `reverse_proxy myapp-app-1:80` (default compose naming)
- or set `container_name`/`hostname` and proxy by that name.

Practical recommendation: set `container_name` and proxy to it.
