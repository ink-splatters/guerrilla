package printer

import "github.com/ink-splatters/guerrilla/pkg/guerrilla"

type Printer interface {
	PrintEmail(email guerrilla.Email)
}

type GuerrillaPrinter interface {
	Printer
	PrintSummary(address string)
}
