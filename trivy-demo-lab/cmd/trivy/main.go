package main

import (
	"fmt"
	"os"

	"github.com/aquasecurity/trivy/pkg/commands"
	"github.com/aquasecurity/trivy/pkg/version"
)

func main() {
	fmt.Printf("Trivy %s\n", version.Version)
	fmt.Println("A comprehensive security scanner for containers and artifacts")

	if err := commands.Execute(); err != nil {
		fmt.Fprintf(os.Stderr, "Error: %v\n", err)
		os.Exit(1)
	}
}
