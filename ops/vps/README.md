# VPS (test)
## Доступ
- SSH только по ключам
- Root-login по SSH отключён
- Администрирование: `nacty` + `sudo`

## Fail2ban (sshd)
Настроено так, чтобы минимизировать самоблокировки при смене IP:
- maxretry=10
- findtime=10m
- bantime=2m
- bantime.increment=true (с ограничением)

Конфиг: `/etc/fail2ban/jail.d/sshd.local`
