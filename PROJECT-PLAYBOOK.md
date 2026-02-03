# Project playbook (no conflicts)
Goal: at any moment we should be able to say “start a new project” and get a predictable baseline: repository, CI, tests, containerization, VPS deploy, documentation.

## Principles (so projects don’t interfere)
1) One project = one repository.
2) One project = one compose stack on the VPS in its own directory: `/opt/apps/<project>`.
3) Projects do NOT publish ports to the public internet (no `ports:`) except the edge stack.
4) All external traffic (80/443) terminates at the edge (Caddy) and is proxied internally via the docker network `edge`.
5) Secrets:
   - never commit to git,
   - never bake into a docker image,
   - store in CI secrets and/or server environment.
6) Rule #5 (dependencies): do not pull a “framework under the hood” preemptively. Every dependency must speed us up now and not lock us in later.
7) Language policy: English-first for README/docs/code comments/issues/PRs.

The canonical principles text lives in `docs/principles.md` (in `t1`) and is copied into every new project.

## Standard project repository structure
Minimum:
- `README.md` (how to run locally + how to deploy)
- `docs/architecture.md` (short architecture / boundaries)
- `docs/principles.md` (engineering principles + Rule #5)
- `scripts/ci.ps1` (local + CI checks)
- `.github/workflows/ci.yml` (CI)
- `ops/` (infra/deploy artifacts, if needed)

## Multi-repo + contracts (recommended standard)
For a product, use separate repositories:
- `<product>-api`
- `<product>-web`
- `<product>-mobile`
- `<product>-contracts` (source of truth)

### Code-first (API)
- Implement the API in FastAPI (code-first) and generate OpenAPI from code.
- OpenAPI is automatically published to `<product>-contracts` via GitHub Actions from the API repo.
- Web/Mobile do not guess DTOs: they generate types/client from contracts.

## CI/CD (baseline)
### CI
Baseline pipeline:
- formatting/lint
- tests
- build (if applicable)
- artifacts (optional)

### Dependency PR rule (required)
If a PR adds/updates dependencies or changes base images (e.g. `pyproject.toml`, `package.json`, `go.mod`, Docker base image), the PR description must include the justification block (use-case/alternatives/exit plan/footprint/security). Canonical format is in `docs/principles.md` and enforced via `.github/pull_request_template.md`.

### CD (test VPS)
Default model:
- manual deploy (workflow_dispatch) or deploy on merge to main (per-project decision)
- deploy is done via docker compose on the VPS

## Tests
Minimum for a new project:
- 1 smoke test (startup)
- 1 unit test
- (for web/API) 1 HTTP integration test

## Architecture (short and useful)
Template file: `docs/architecture.md`.
Contents:
- purpose and system boundaries
- main components
- storages/queues (if any)
- APIs/contracts
- environments (dev/test/prod)
- risks and decisions

## Containerization (Docker)
Prepare:
- `Dockerfile`
- `docker-compose.yml` without public port publishing
- attach to external network `edge`

Rule:
- if HTTP is needed, the app listens on an internal port, and edge proxies to it.

## VPS deploy (production-like baseline)
Invariants:
- edge stack: `/opt/t1/edge` (Caddy+TLS)
- projects: `/opt/apps/<project>`
- shared network: docker network `edge` (external)

Process:
1) Create a project deploy directory in the repo (e.g. `ops/vps/apps/<project>`).
2) Deploy to the VPS at `/opt/apps/<project>` via `scripts/deploy-vps.ps1` (or equivalent).
3) Add routing in `ops/vps/edge/Caddyfile`:
   - path-based (e.g. `/myapp/*`)
   - or dedicated subdomain (recommended for real services)
4) Reload edge: `cd /opt/t1/edge && docker compose up -d`.

## What I do automatically (routine)
On “create project <name>” I typically:
- create/init a repo from `t1`
- add structure and minimal checks
- configure CI
- prepare docker-compose for behind-edge deploy
- update docs (repo + `OneDrive/Projects/nactyx-infra.md`)

## What is considered critical (I’ll ask for a short confirmation)
- access changes: SSH/firewall/ports
- installing/removing system packages/services on the VPS
- edge routing changes that may affect existing domains
- data migrations / data operations
- production deploy (once prod exists)
