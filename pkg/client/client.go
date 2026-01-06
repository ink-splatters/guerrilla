package client

type Client interface {
	GetNewEmails() ([]EmailSummary, error)
	GetEmail(id string) (*Email, error)
	GetAddress() string
}

func WithOptions(options ...Option) (Client, error) {
	client := DefaultClient
	for _, option := range options {
		option(&client)
	}
	if err := client.init(); err != nil {
		return nil, err
	}
	return &client, nil
}
