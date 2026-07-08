#!/bin/bash
set -e

BINDIR=${BINDIR:-./bin}
mkdir -p $BINDIR

echo "Installing Trivy..."
curl -sfL https://github.com/aquasecurity/trivy/releases/download/v0.71.0/trivy_0.71.0_Linux-64bit.tar.gz | tar xz -C $BINDIR
echo "Trivy installed to $BINDIR/trivy"
