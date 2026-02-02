# App template (behind edge)
Этот шаблон показывает, как запускать приложение Docker Compose без публикации портов наружу.

## Идея
- Edge (Caddy) слушает 80/443 на хосте.
- Приложения подключаются к общей docker network `edge` и доступны edge-реверс-прокси по внутреннему DNS имени сервиса.

## Что нужно сделать для нового приложения
1) Скопировать этот шаблон в `ops/vps/apps/<app-name>/`.
2) Задеплоить на VPS в `/opt/apps/<app-name>` через `scripts/deploy-vps.ps1`.
3) Добавить правило reverse_proxy в `ops/vps/edge/Caddyfile`.

## Пример reverse_proxy
Если ваш compose проект называется `myapp`, сервис внутри него называется `app`, и он слушает 80, то в Caddyfile:
- `reverse_proxy myapp-app-1:80` (если используете дефолтные compose имена)
- или задайте `container_name`/`hostname` и проксируйте по нему.

Практический вариант: в compose задать `container_name` и проксировать по нему.
