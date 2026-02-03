# Working with the agent

## How to describe tasks
Always include:
1) Goal (what the final outcome should be)
2) Context (repo/branch/path/service/server)
3) Constraints (what must not be touched)
4) Definition of done (which checks/tests must pass)

## Canonical repository commands
- CI (local + GitHub Actions):
  - `pwsh ./scripts/ci.ps1`

## Starting a new project
See `PROJECT-PLAYBOOK.md` — the default playbook to start new projects without conflicts (git, CI, tests, docker, behind-edge deploy, docs).

## Change policy and confirmations
### What I do without asking
- I run terminal commands myself (you don’t need to copy/paste or execute commands).
- Routine work: code investigation, file edits, running tests/linters, preparing commits/PRs, deploying to test when the scheme is already agreed.

### What I treat as critical (I’ll ask for a short “yes/ok”)
- access/network: SSH/firewall/ports
- installing/removing system packages or services on the VPS
- edge routing changes that might affect existing domains
- data migrations / data operations
- changes that are not easy to roll back quickly

## Security note
Never paste secrets/passwords into chat. Access uses SSH keys; secrets are stored in CI secrets and/or server environment.
