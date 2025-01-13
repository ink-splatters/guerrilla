package printer

import "github.com/liamg/guerrilla/pkg/guerrilla"

type Printer interface {
	PrintEmail(email guerrilla.Email)
}

type GuerrillaPrinter interface {
	Printer
	PrintSummary(address string)
}
