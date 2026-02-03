# Engineering principles (global standard)
This document is the required baseline for all projects. New repositories copy it from `t1` and may extend it, but must not contradict the base rules.

## Goals
- Move fast using proven, standard building blocks.
- Keep flexibility (avoid getting trapped by a “mega-framework”).
- Keep dependencies lean and maintenance predictable.

## Language policy (English-first)
All project-facing text is written in English:
- README and docs
- code comments (when meaningful)
- issues/PRs and PR descriptions
- templates (e.g. `.github/pull_request_template.md`)

(Operational notes can also be kept in English for consistency.)

## Principles
1) Build the minimum skeleton that provides immediate value (CI, tests, docker, behind-edge deploy, docs).
2) Contracts are the source of truth (for APIs: code-first OpenAPI → auto-published to a contracts repo).
3) Deploy behind the edge: apps do not publish public ports; edge (Caddy) terminates 80/443 and proxies internally via docker network `edge`.
4) Secrets:
   - never commit to git,
   - never bake into a docker image,
   - store in CI secrets and/or server environment.

## Rule #5 (the key one): dependencies and “frameworks under the hood”
Before adding a dependency, ask:
1) Does it speed us up right now for a concrete use-case?
2) Will it avoid locking us in 1–2 months from now (architecture/data/migrations/customization)?

Practical rules:
- Don’t add heavy frameworks “just in case”. Add only when there is a real need.
- For each area, pick one tool (no 2 ORMs / 2 queues / 2 DI containers).
- Any new dependency should be:
  - widely used,
  - actively maintained,
  - with a clear license,
  - with a reasonable footprint.
- If a dependency is added mainly for “magic”, it must come with a simple exit plan.

## PR requirement for dependency / base image changes
If a PR adds/updates dependencies or changes base images (e.g. `pyproject.toml`, `package.json`, `go.mod`, Docker base image), the PR description must include:
- Use-case: what problem we solve and why now
- Alternatives: 1–2 alternatives considered and why rejected
- Lock-in / Exit plan: how we roll back or replace if this choice turns out wrong
- Footprint: impact on image size, build time, runtime resources
- Security / License: new risks (CVE surface, maintenance status, license)

This is also enforced via `.github/pull_request_template.md`.

## Recommended API baseline kit (FastAPI)
A speed+flex baseline without overkill:
- FastAPI + Pydantic (DTO/validation)
- Settings: `pydantic-settings`
- DB: Postgres + SQLAlchemy 2 + Alembic (migrations)
- Auth: JWT + refresh; passwords via `passlib[argon2]` (or equivalent)
- Roles/permissions: simple RBAC via dependencies (policy engine only if truly needed)
- Background jobs/queues: do not add upfront; add when a concrete use-case appears
