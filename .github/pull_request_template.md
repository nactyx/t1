# Summary

## Checklist
- [ ] CI is green locally/CI
- [ ] Docs updated (if needed)

## Dependency / base image changes (required if applicable)
If this PR changes dependencies or base images (`pyproject.toml`, `package.json`, `go.mod`, Docker base image, etc.), fill in:
- Use-case: what problem are we solving and why now?
- Alternatives: 1–2 alternatives considered and why they were rejected
- Lock-in / Exit plan: how to roll back or replace if this choice turns out wrong
- Footprint: impact on image size, build time, runtime resources
- Security / License: new risks (CVE surface, maintenance status, license)