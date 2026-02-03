# VPS production baseline (template)
This directory documents a production-like VPS baseline: access, security, edge/TLS, app deployments, and where configs live.

## Server (current test instance)
- IP: 89.40.204.19
- OS: Ubuntu 24.04.3 LTS
- Admin user: `nacty`

## Access and security
### SSH
- Root SSH login disabled.
- PasswordAuthentication disabled (key-only auth).
- Drop-in config: `/etc/ssh/sshd_config.d/99-warp-hardening.conf`

### Sudo
- Passwordless sudo is enabled for automation:
  - `/etc/sudoers.d/90-nacty-nopasswd`

### Fail2ban
- jail: `sshd`
- Goal: minimize self-lockouts when IP changes (incl. VPN) while keeping brute-force protection.
- Config: `/etc/fail2ban/jail.d/sshd.local`
- Effective parameters:
  - `maxretry = 10`
  - `findtime = 10m`
  - `bantime = 2m`
  - `bantime.increment = true`, `bantime.maxtime = 30m`

### Firewall (UFW)
- UFW enabled.
- Default policy: deny incoming, allow outgoing.
- Allowed:
  - 22/tcp (limit)
  - 80/tcp
  - 443/tcp
- Check: `ufw status verbose`

## Edge / TLS
Edge is Docker Compose + Caddy (Let’s Encrypt).
- Local source: `ops/vps/edge/`
- On server: `/opt/t1/edge`
- Docker network: `edge` (external) — both edge and apps attach to it for `reverse_proxy`.
- Domains:
  - `nactyx.devourer.beget.tech`
  - `www.nactyx.devourer.beget.tech`

### Important: applying Caddyfile changes
`Caddyfile` is bind-mounted into the container. Updating the file on disk does not automatically reload Caddy.
After changing `Caddyfile`, run:
- `cd /opt/t1/edge && docker compose up -d`
- `docker exec t1-edge-caddy caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile`

Note: Caddy container uses `dns: 1.1.1.1, 8.8.8.8` because the default Docker resolver failed to resolve `acme-v02.api.letsencrypt.org`.

## Deploy
Generic deployment helper:
- `scripts/deploy-vps.ps1`

Pattern:
- each project (compose stack) lives in its own directory on the server (e.g. `/opt/apps/<name>`)
- deploy = copy files + `docker compose up -d`

## Post-change checks
Minimal smoke checklist:
- `ssh vps-test "echo ok"`
- `ssh vps-test "sudo -n true"`
- `sshd -t` (before ssh reload/restart)
- `fail2ban-client status sshd`
- `docker compose ps` for edge
- (after any `Caddyfile` change) `docker exec t1-edge-caddy caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile`
- `curl -I https://nactyx.devourer.beget.tech/`

## Rollback (critical)
- SSH hardening:
  - remove/rename `/etc/ssh/sshd_config.d/99-warp-hardening.conf` and `systemctl reload ssh`
- Fail2ban:
  - restore from `/etc/fail2ban/jail.d/sshd.local.bak.*` and `fail2ban-client reload`
- Edge:
  - `cd /opt/t1/edge && docker compose down` (or roll back to previous compose)
