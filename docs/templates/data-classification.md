# Data classification

## Classes
- Public: safe to publish externally
- Internal: safe inside the team/project, not public
- Private: user-personal, must be access-controlled
- Sensitive: high impact if leaked (health, financial, auth secrets)

## Rules
- Do not put Sensitive/Private data into logs, analytics, or error tracking by default.
- Define explicit export/delete flows.
- Encrypt at rest where applicable; restrict access by least privilege.

## Storage map (fill in)
- <domain/table/bucket> -> <class> -> <retention> -> <access>
