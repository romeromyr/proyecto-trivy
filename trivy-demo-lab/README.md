# Trivy

[![GitHub Release][release-img]][release]
[![Test][test-img]][test]
[![Go Report Card][go-report-img]][go-report]
[![License: Apache-2.0][license-img]][license]
[![GitHub Downloads][github-downloads-img]][release]

![Trivy](docs/assets/trivy-logo.png)

Trivy is a comprehensive and versatile security scanner. Trivy has scanners that look for security issues, and targets where it can find those issues.

Targets (what Trivy can scan):

- Container Image
- Filesystem
- Git Repository (remote)
- Virtual Machine Image
- Kubernetes
- AWS

Scanners (what Trivy can find there):

- OS packages and software dependencies in use (SBOM)
- Known vulnerabilities (CVEs)
- IaC issues and misconfigurations
- Sensitive information and secrets
- Software licenses

## Quick Start

### Scan container image

Simply specify an image name (and a tag).

```bash
$ trivy image python:3.4-alpine
```

### Scan filesystem

Simply specify a sub-directory to scan.

```bash
$ trivy fs /path/to/project
```

## Documentation

The official documentation, which provides detailed installation instructions, usage guides, and other resources, is available at https://aquasecurity.github.io/trivy/.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for instructions on how to contribute.

## Security

Please see [SECURITY.md](SECURITY.md) for security-related information.

## License

This project is licensed under the Apache 2.0 license — see the [LICENSE](LICENSE) file for details.

[release]: https://github.com/aquasecurity/trivy/releases
[release-img]: https://img.shields.io/github/release/aquasecurity/trivy.svg?logo=github
[test-img]: https://github.com/aquasecurity/trivy/actions/workflows/test.yaml/badge.svg
[go-report]: https://goreportcard.com/report/github.com/aquasecurity/trivy
[go-report-img]: https://goreportcard.com/badge/github.com/aquasecurity/trivy
[license]: https://github.com/aquasecurity/trivy/blob/main/LICENSE
[license-img]: https://img.shields.io/badge/License-Apache%202.0-blue.svg
[github-downloads-img]: https://img.shields.io/github/downloads/aquasecurity/trivy/total?logo=github
