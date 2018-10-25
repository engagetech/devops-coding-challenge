package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"
)

func check(url string) (time.Duration, error) {
	var err error
	var resp *http.Response
	now := time.Now().UTC()

	resp, err = http.Get(url)
	if err != nil {
		return 0, err
	}
	defer resp.Body.Close()

	var body []byte
	body, err = ioutil.ReadAll(resp.Body)
	if err != nil {
		return 0, err
	}

	const layout = "2006-01-02 15:04:05.999999999 -0700 MST"
	var remoteTime time.Time
	remoteTime, err = time.Parse(layout, string(body))
	if err != nil {
		return 0, err
	}

	return remoteTime.Sub(now), nil
}

func main() {
	args := os.Args
	if len(os.Args) != 2 {
		fmt.Printf("Usage:\n%s <url>\n", os.Args[0])
		os.Exit(1)
	}

	for {
		diff, err := check(args[1])
		if err != nil {
			log.Printf("An error occurred: %s", err)
		} else {
			if diff.Seconds() > 1 {
				fmt.Printf("Clock desynchronized. Time diff: %fs\n", diff.Seconds())
			} else {
				fmt.Printf("Clock synchronized. Time diff: %fs\n", diff.Seconds())
			}
		}
		time.Sleep(2 * time.Second)
	}

}
