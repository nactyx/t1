# VPS production baseline (template)
Эта папка фиксирует «боевой» шаблон для VPS: как устроены доступ, безопасность, edge (TLS), деплой приложений и где искать конфиги.

## Сервер (текущий тестовый)
- IP: 89.40.204.19
- ОС: Ubuntu 24.04.3 LTS
- Админ-пользователь: `nacty`

## Доступ и безопасность
### SSH
- Root login по SSH отключён.
- PasswordAuthentication по SSH отключён (вход только по ключам).
- Drop-in конфиг: `/etc/ssh/sshd_config.d/99-warp-hardening.conf`

### Sudo
- Для автоматизации включён passwordless sudo:
  - `/etc/sudoers.d/90-nacty-nopasswd`

### Fail2ban
- jail: `sshd`
- Цель: минимизировать самоблокировки при смене IP (в т.ч. VPN), но сохранять защиту от брутфорса.
- Конфиг: `/etc/fail2ban/jail.d/sshd.local`
- Параметры (effective):
  - `maxretry = 10`
  - `findtime = 10m`
  - `bantime = 2m`
  - `bantime.increment = true`, `bantime.maxtime = 30m`

### Firewall (UFW)
- UFW включён.
- Политика по умолчанию: входящий deny, исходящий allow.
- Разрешено:
  - 22/tcp (limit)
  - 80/tcp
  - 443/tcp
- Проверить: `ufw status verbose`

## Edge / TLS
Edge реализован через Docker Compose + Caddy (Let’s Encrypt).
- Локальный исходник: `ops/vps/edge/`
- На сервере: `/opt/t1/edge`
- Docker network: `edge` (external) — к ней подключаются и edge, и будущие приложения для reverse_proxy.
- Домены:
  - `nactyx.devourer.beget.tech`
  - `www.nactyx.devourer.beget.tech`

Примечание: в контейнере Caddy задан `dns: 1.1.1.1, 8.8.8.8`, т.к. дефолтный Docker resolver в контейнере не резолвил `acme-v02.api.letsencrypt.org`.

## Деплой
Универсальный деплой через скрипт:
- `scripts/deploy-vps.ps1`

Паттерн:
- каждый проект (compose stack) лежит в своей папке на сервере (например `/opt/apps/<name>` или `/opt/t1/<name>`)
- деплой = скопировать файлы + `docker compose up -d`

## Проверки после изменений
Минимальный smoke checklist:
- `ssh vps-test "echo ok"`
- `ssh vps-test "sudo -n true"`
- `sshd -t` (перед reload/restart ssh)
- `fail2ban-client status sshd`
- `docker compose ps` для edge
- `curl -I https://nactyx.devourer.beget.tech/`

## Rollback (критично)
- SSH hardening:
  - удалить/переименовать `/etc/ssh/sshd_config.d/99-warp-hardening.conf` и `systemctl reload ssh`
- Fail2ban:
  - вернуть предыдущий конфиг из `/etc/fail2ban/jail.d/sshd.local.bak.*` и `fail2ban-client reload`
- Edge:
  - `cd /opt/t1/edge && docker compose down` (или rollback на предыдущий compose)
