# t1
Template repository for my projects (web/mobile/embedded) and routine automation.

## Quick start
1) Clone the repository.
2) Run local checks:
   - `pwsh ./scripts/ci.ps1`

## Working with the agent
- `AGENTS.md` — interaction rules and what requires confirmation.
- `PROJECT-PLAYBOOK.md` — how to start a new project without conflicts (CI/tests/docker/deploy/docs).
- `docs/principles.md` — engineering principles + dependency policy (Rule #5).

## Test VPS notes
Access is SSH key-only. Root SSH login is disabled; administration is done via user `nacty` + `sudo`.

SSH host aliases live in `~/.ssh/config` (e.g. `vps-test`).
