package main

import (
  "time"
  "net/http"
  "io"
  "log"
)

func main() {
  http.HandleFunc("/now", nowTime)
  if err := http.ListenAndServe(":8080", nil); err != nil {
    log.Printf("An error ocurred: %s\n", err)
  }
}

func nowTime(w http.ResponseWriter, r *http.Request) {
  io.WriteString(w, time.Now().UTC().String())
}
