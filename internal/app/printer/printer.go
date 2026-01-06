package printer

import "github.com/ink-splatters/guerrilla/pkg/types"

type Printer interface {
	PrintEmail(email types.Email)
}

type GuerrillaPrinter interface {
	Printer
	PrintSummary(address string)
}
