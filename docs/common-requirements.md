# Common requirements (engineering baseline)
This document is compiled from:
- `t1` template repo: `AGENTS.md`, `PROJECT-PLAYBOOK.md`, `docs/principles.md`
- `baseapi-api` reference implementation (FastAPI + code-first OpenAPI)
- Infra source of truth: `nactyx-infra.md` (private/local; keep updated after infra changes)

## 1) Language policy
English-first for:
- README and docs
- code comments (when meaningful)
- issues/PRs and PR descriptions

(Non-English notes may exist, but English is canonical.)

## 2) Repository baseline (minimum)
Core:
- `README.md` (local run + local checks + deploy notes)
- `AGENTS.md` (how to work with the agent + confirmations policy)
- `docs/common-requirements.md` (this file; copied from `t1`)
- `docs/architecture.md` (short: boundaries/components/integrations/environments/risks)
- `docs/principles.md` (required baseline: Rule #5 + dependency PR block)

Automation:
- `scripts/ci.ps1` and `.github/workflows/ci.yml`
- `.github/pull_request_template.md`
- `.github/dependabot.yml` (at least GitHub Actions updates)

Repo hygiene:
- `.editorconfig`, `.gitattributes`
- `LICENSE` (explicit licensing baseline)
- `SECURITY.md`
- `CONTRIBUTING.md`
- `.github/CODEOWNERS` (recommended)
- `.github/ISSUE_TEMPLATE/*` (recommended)

Optional templates:
- `docs/templates/*` (ADR, privacy/data/threat model starters)

## 3) Dependency rule (Rule #5)
Before adding a dependency or “framework under the hood”, confirm:
- it speeds us up now for a concrete use-case
- it will not lock us in 1–2 months from now

Practical constraints:
- don’t add heavy frameworks “just in case”
- one tool per area (no 2 ORMs / 2 queues / 2 DI containers)
- widely used, actively maintained, clear license, reasonable footprint
- if the value is mostly “magic”, require a simple exit plan

## 4) CI expectations
Canonical local check entrypoint:
- `pwsh ./scripts/ci.ps1`

Baseline should cover:
- formatting/lint
- tests
- build/export sanity (if applicable)

## 5) PR requirements
If a PR changes dependencies or base images (`pyproject.toml`, `package.json`, `go.mod`, Docker base image, etc.), the PR description must include:
- Use-case
- Alternatives
- Lock-in / Exit plan
- Footprint
- Security / License

## 6) Architecture style (recommended)
- Prefer a modular monolith (“DDD-lite”) with explicit boundaries.
- Keep the HTTP layer thin; push business rules into domain/use-case modules.

## 7) API contracts (when the project has an API)
- Code-first OpenAPI generated from the service implementation.
- Publish the spec to a separate contracts repo via CI.
- Web/Mobile generate DTOs/clients from contracts (do not guess types).

## 8) Secrets & configuration
Rules:
- secrets must never end up in git
- secrets must never be baked into docker images

Recommended split:
- env vars for secrets/runtime (`*_JWT_SECRET`, DB password, SMTP password, etc.)
- a non-secret YAML file for feature flags/domains/URLs

Optional standard:
- Bitwarden as secrets source of truth + CLI-assisted deploy scripts that upload a runtime `.env` to the VPS.

## 9) Deploy model (behind edge)
Standard VPS model:
- apps do not publish public ports in compose stacks
- all external traffic terminates at the edge proxy (Caddy)
- internal routing happens via the external docker network `edge`
- per-app remote dir: `/opt/apps/<project>`

## 10) Infra inventory + change log
After any infra/deploy/routing change, update `nactyx-infra.md`:
- servers/domains
- deployed apps inventory
- changes log entry (what changed + where + rollback notes)

## 11) Confirmations for infra-sensitive operations
Ask first for:
- SSH/firewall/ports
- edge routing changes that might affect existing domains
- data migrations / data operations
- installing/removing system packages/services on a VPS
