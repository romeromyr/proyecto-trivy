package commands

import (
	"fmt"

	"github.com/spf13/cobra"
)

var rootCmd = &cobra.Command{
	Use:   "trivy",
	Short: "A comprehensive security scanner",
	Long: `Trivy is a simple and comprehensive scanner for vulnerabilities
in container images, file systems, and Git repositories.`,
}

func Execute() error {
	return rootCmd.Execute()
}

func init() {
	rootCmd.AddCommand(imageCmd)
	rootCmd.AddCommand(fsCmd)
	rootCmd.AddCommand(versionCmd)
}

var imageCmd = &cobra.Command{
	Use:   "image [IMAGE_NAME]",
	Short: "Scan a container image",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Scanning image: %s\n", args[0])
		fmt.Println("No vulnerabilities found (demo mode)")
	},
}

var fsCmd = &cobra.Command{
	Use:   "filesystem [PATH]",
	Short: "Scan a local filesystem",
	Args:  cobra.ExactArgs(1),
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Scanning filesystem: %s\n", args[0])
		fmt.Println("No vulnerabilities found (demo mode)")
	},
}

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Print the version",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println("Trivy v0.71.0 (demo)")
	},
}
