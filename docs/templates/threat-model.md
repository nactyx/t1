# Threat model (lightweight)

## Assets
What are we protecting?

## Entry points
- web/mobile clients
- API
- admin tooling
- CI/CD

## Threats to consider
- data leakage via logs/analytics
- broken access control (IDOR)
- token/session theft
- SSRF / injection
- supply-chain (dependencies)

## Mitigations
List the concrete mitigations we implement.
