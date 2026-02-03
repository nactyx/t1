# VPS (test)

## Access
- SSH key-only
- Root SSH login disabled
- Administration: `nacty` + `sudo`

## Fail2ban (sshd)
Configured to minimize self-lockouts when your IP changes:
- maxretry=10
- findtime=10m
- bantime=2m
- bantime.increment=true (with a cap)

Config: `/etc/fail2ban/jail.d/sshd.local`
