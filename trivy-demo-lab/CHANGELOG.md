# Changelog

## [0.71.0] (2026-06-15)

### Features
- feat(scanner): add support for new CVE database format
- feat(report): improve SARIF output formatting

### Bug Fixes
- fix(github): resolve workflow injection vulnerability in pull_request_target
- fix(docker): update base image to alpine 3.24.1

### Security
- Security fix for supply chain workflow configuration
- Rotated all production tokens after incident response

## [0.70.0] (2026-05-01)

### Features
- feat(aws): add ECR native scanning support
- feat(helm): update chart to support new Kubernetes versions

### Bug Fixes
- fix(fs): resolve symlink traversal issue
