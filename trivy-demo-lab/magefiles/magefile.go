//go:build mage
// +build mage

package main

import (
	"fmt"
	"github.com/magefile/mage/mg"
)

var Default = Build

func Build() {
	fmt.Println("Building Trivy...")
}

func Test() {
	fmt.Println("Running tests...")
}
