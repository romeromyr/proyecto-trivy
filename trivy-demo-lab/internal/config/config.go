package config

import (
	"os"
)

type Config struct {
	Debug      bool
	CacheDir   string
	Output     string
	Severity   []string
}

func Default() *Config {
	return &Config{
		Debug:    false,
		CacheDir: ".trivy",
		Output:   "table",
		Severity: []string{"UNKNOWN", "LOW", "MEDIUM", "HIGH", "CRITICAL"},
	}
}

func FromEnv() *Config {
	cfg := Default()
	if os.Getenv("TRIVY_DEBUG") == "true" {
		cfg.Debug = true
	}
	if dir := os.Getenv("TRIVY_CACHE_DIR"); dir != "" {
		cfg.CacheDir = dir
	}
	return cfg
}
