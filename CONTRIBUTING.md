# Contributing

## Ground rules
- English-first for repo-facing text (README/docs/issues/PRs).
- Keep the codebase lean (see Rule #5 in `docs/principles.md`).

## Local checks
Run the canonical checks:
- `pwsh ./scripts/ci.ps1`

## Pull requests
- Keep PRs small and focused.
- Update docs when behavior/architecture changes.

### Dependency / base image change rule (required)
If a PR adds/updates dependencies or changes base images (`pyproject.toml`, `package.json`, `go.mod`, Docker base image, etc.), the PR description must include:
- Use-case
- Alternatives
- Lock-in / Exit plan
- Footprint
- Security / License

(Template is in `.github/pull_request_template.md`.)
