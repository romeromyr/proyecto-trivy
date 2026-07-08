# Trivy Documentation

Welcome to the Trivy documentation. Trivy is a comprehensive security scanner.

## Quick Links

- [Getting Started](getting-started/quickstart.md)
- [Scanning Images](scanning/image.md)
- [Configuration](configuration/index.md)
- [Contributing](contributing/index.md)

## Architecture

Trivy follows a modular architecture with the following components:

1. **Scanner Engine**: Core vulnerability detection logic
2. **Database**: Local cache of vulnerability information
3. **Report Generator**: Formats output (SARIF, JSON, Table)
4. **CI/CD Integration**: GitHub Actions, GitLab CI, Azure DevOps

## Security Notice

⚠️ **Important**: Always verify artifact signatures using Cosign before deployment.
