package main

import (
	"fmt"

	"github.com/ink-splatters/guerrilla/pkg/guerrilla"
)

func main() {
	client, err := guerrilla.Init()
	if err != nil {
		panic(err)
	}

	poller := guerrilla.NewPoller(client)

	for email := range poller.Poll() {
		fmt.Printf("Email received: Subject=%s\nBody=%s\n\n", email.Subject, email.Body)
	}

}
