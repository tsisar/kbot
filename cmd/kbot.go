/*
Copyright © 2025 NAME HERE <EMAIL ADDRESS>
*/
package cmd

import (
	"fmt"
	"gopkg.in/telebot.v3"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"
)

var Token = os.Getenv("TELE_TOKEN")

// kbotCmd represents the kbot command
var kbotCmd = &cobra.Command{
	Use:     "kbot",
	Aliases: []string{"start"},
	Short:   "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		log.Printf("kbot %s called", appVersion)
		kbot, err := telebot.NewBot(telebot.Settings{
			URL:    "",
			Token:  Token,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		})
		if err != nil {
			log.Fatalf("error creating bot: %v", err)
			return
		}

		kbot.Handle(telebot.OnText, func(m telebot.Context) error {
			log.Printf(m.Message().Payload, m.Text())
			payload := m.Text()

			switch payload {
			case "hello":
				if err := m.Send(fmt.Sprintf("Hello, %s!\nI'm Kbot %s", m.Message().Sender.FirstName, appVersion)); err != nil {
					log.Printf("error replying to message: %v", err)
					return err
				}
			default:
				if err := m.Send(fmt.Sprintf("Сам ти %s!", payload)); err != nil {
					log.Printf("error replying to message: %v", err)
					return err
				}
			}

			return err
		})

		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(kbotCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// kbotCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// kbotCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
