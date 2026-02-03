# Server inventory

## VPS: test-1
- IP: 89.40.204.19
- Host alias (local): `vps-test`
- OS: Ubuntu 24.04.3 LTS
- Admin: `nacty` (passwordless sudo)

### Network ports (expected)
- 22/tcp: SSH (UFW limit)
- 80/tcp: HTTP (Caddy, redirect to HTTPS)
- 443/tcp: HTTPS (Caddy)

### Directories
- `/opt/t1/edge` — edge stack
- `/opt/apps` — application stacks (compose projects)
- `/opt/edge` → symlink to `/opt/t1/edge`

### Docker
- Docker Engine: 29.2.1
- Docker Compose plugin: v5.0.2

### Deployed stacks (Docker Compose)
1) Edge (TLS)
- Purpose: TLS termination + static / reverse-proxy
- Server path: `/opt/t1/edge`
- Container: `t1-edge-caddy`
- Domains:
  - nactyx.devourer.beget.tech
  - www.nactyx.devourer.beget.tech

2) First deploy (HTTP-only) — historical
- Server path: `/opt/t1/first-deploy`
- Used for initial smoke deploy; currently disabled.
