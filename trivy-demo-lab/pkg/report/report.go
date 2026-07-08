package report

import (
	"fmt"
	"time"
)

type Report struct {
	Target          string
	ScanType        string
	Timestamp       time.Time
	Vulnerabilities []Vulnerability
}

type Vulnerability struct {
	ID          string
	Severity    string
	Title       string
	Description string
	Package     string
	FixedVersion string
}

func New(target, scanType string) *Report {
	return &Report{
		Target:    target,
		ScanType:  scanType,
		Timestamp: time.Now(),
	}
}

func (r *Report) AddVuln(v Vulnerability) {
	r.Vulnerabilities = append(r.Vulnerabilities, v)
}

func (r *Report) Print() {
	fmt.Printf("Report for: %s\n", r.Target)
	fmt.Printf("Scan type: %s\n", r.ScanType)
	fmt.Printf("Timestamp: %s\n", r.Timestamp.Format(time.RFC3339))
	fmt.Printf("Vulnerabilities found: %d\n", len(r.Vulnerabilities))
	for _, v := range r.Vulnerabilities {
		fmt.Printf("  [%s] %s - %s\n", v.Severity, v.ID, v.Title)
	}
}
