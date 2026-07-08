# Quick Start

## Installation

### Linux/macOS
```bash
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
```

### Windows
```powershell
choco install trivy
```

## First Scan

```bash
trivy image python:3.4-alpine
```

## CI/CD Integration

See `.github/workflows/` for examples.
