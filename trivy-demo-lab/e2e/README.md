# End-to-End Tests

This directory contains end-to-end tests for Trivy.
These tests run against real container images and registries.

## Running E2E Tests

```bash
go test ./e2e/... -v
```

## Test Coverage

- Container image scanning
- Filesystem scanning
- Git repository scanning
- Kubernetes cluster scanning
- CI/CD pipeline integration
