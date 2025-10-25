package main

import "github.com/ink-splatters/guerrilla/internal/app/cmd"

var Version = "dev"

func main() {
	cmd.SetVersion(Version)
	cmd.Execute()
}
