package printer

import (
	"fmt"
	"io"
	"time"

	"github.com/liamg/guerrilla/pkg/guerrilla"
)

type plaintextPrinter struct {
	w io.Writer
}

func NewPlaintextPrinter(w io.Writer) Printer {
	return &plaintextPrinter{
		w: w,
	}
}

func (p *plaintextPrinter) PrintEmail(email guerrilla.Email) {

	fmt.Println("Email #" + email.ID)

	fmt.Printf("Subject:       %s\n", email.Subject)
	fmt.Printf("From:          %s\n", email.From)
	fmt.Printf("Time:          %s\n", email.Timestamp.Format(time.RFC1123))
	fmt.Printf("ContentType:   %s\n", email.ContentType)
	fmt.Printf("RefMid:        %s\n", email.RefMid)
	fmt.Printf("Size:          %d\n", email.Size)
	fmt.Println("")

	fmt.Println(email.Body)
}
