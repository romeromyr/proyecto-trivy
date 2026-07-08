# Integration Tests

Integration tests for Trivy scanner components.

## Running Tests

```bash
go test ./integration/... -v
```

## Components Tested

- Vulnerability database updater
- Package analyzers
- Report formatters
- Cache management
