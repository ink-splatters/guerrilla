package guerrilla

import (
	"fmt"
	"os"
	"time"

	"github.com/ink-splatters/guerrilla/internal/app/printer"
	"github.com/ink-splatters/guerrilla/pkg/client"
	"github.com/spf13/cobra"
)

var Version = "dev"

var rootCmd = &cobra.Command{
	Use:   "guerrilla",
	Short: "Guerrilla is a command line tool for creating a temporary email address and receiving associated email in the terminal. Powered by the Guerrilla Mail API.",
	RunE: func(cmd *cobra.Command, args []string) error {

		var (
			mailPrinter printer.Printer
		)

		cmd.SilenceUsage = true
		cmd.SilenceErrors = true

		client, err := client.New()
		if err != nil {
			return err
		}

		if flagPollIntervalSeconds < 1 || flagPollIntervalSeconds > 600 {
			return fmt.Errorf("poll-interval must be between 1-600")
		}

		genericPrinter := printer.NewGuerrillaPrinter(cmd.OutOrStdout())
		mailPrinter = func() printer.Printer {
			if plaintext {
				return printer.NewPlaintextPrinter(cmd.OutOrStdout())
			}

			return genericPrinter
		}()

		genericPrinter.PrintSummary(client.GetAddress())

		poller := client.NewPoller(client, client.PollOptionWithInterval(time.Second*time.Duration(flagPollIntervalSeconds)))
		var count int
		for email := range poller.Poll() {
			if !showWelcomeEmail && count == 0 && email.Subject == "Welcome to Guerrilla Mail" {
				continue
			}
			mailPrinter.PrintEmail(email)
			count++
		}

		return nil
	},
}

var (
	flagPollIntervalSeconds int

	plaintext        bool
	showWelcomeEmail bool
)

func Execute() {

	rootCmd.Flags().IntVarP(&flagPollIntervalSeconds, "poll-interval", "i", 30, "Poll interval in seconds. Must be between 1-600. Low values are not recommended due to API rate limits.")
	rootCmd.Flags().BoolVarP(&showWelcomeEmail, "show-welcome", "w", false, "Show the default GuerrillaMail welcome email in the output (filtered by default).")
	rootCmd.Flags().BoolVarP(&plaintext, "plaintext", "p", false, "Wether print e-mails in plaintext (useful for copying).")

	rootCmd.Version = Version

	if err := rootCmd.Execute(); err != nil {
		_, _ = fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}
