package main

import (
	"log"
	"os"
	"os/signal"
	"syscall"

	"golang.org/x/net/context"
)

const (
	defaultServerPort = 8080
	v1VersionCode     = "blue"
	v2VersionCode     = "green"
)

var (
	logger  = log.New(os.Stdout, "[ttv] ", log.Lshortfile|log.Ldate|log.Ltime)
	version = v1VersionCode
)

func main() {

	// init context
	_, ctxCancel := context.WithCancel(context.Background())

	// init wait for CTRL-C
	go func() {
		ch := make(chan os.Signal)
		signal.Notify(ch, syscall.SIGINT, syscall.SIGTERM)
		logger.Println(<-ch)
		ctxCancel()
		os.Exit(0)
	}()

	// init web server
	if err := startServer(defaultServerPort); err != nil {
		logger.Fatal(err)
		return
	}

}
