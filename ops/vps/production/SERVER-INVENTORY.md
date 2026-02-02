# Server inventory
## VPS: test-1
- IP: 89.40.204.19
- Host alias (локально): `vps-test`
- ОС: Ubuntu 24.04.3 LTS
- Админ: `nacty` (passwordless sudo)

### Сетевые порты (ожидаемые)
- 22/tcp: SSH (UFW limit)
- 80/tcp: HTTP (Caddy, редирект на HTTPS)
- 443/tcp: HTTPS (Caddy)

### Директории
- `/opt/t1/edge` — edge stack
- `/opt/apps` — будущие приложения (compose-проекты)
- `/opt/edge` → symlink на `/opt/t1/edge`

### Docker
- Docker Engine: 29.2.1
- Docker Compose plugin: v5.0.2

### Развёрнутые стеки (Docker Compose)
1) Edge (TLS)
- Назначение: termination TLS + статика/реверс-прокси
- Путь на сервере: `/opt/t1/edge`
- Контейнер: `t1-edge-caddy`
- Домены:
  - nactyx.devourer.beget.tech
  - www.nactyx.devourer.beget.tech

2) First deploy (HTTP-only) — исторически
- Путь на сервере: `/opt/t1/first-deploy`
- Стек был нужен для первого smoke deploy, сейчас выключен.
