package main

import (
    "fmt"
    "net/http"
    "os"
)

func main() {
    message := os.Getenv("MESSAGE")
    if message == "" {
        message = "Hello, world!"
    }

    port := os.Getenv("APP_PORT")
    if port == "" {
        port = "8080" // Port par défaut
    }

    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, `{"message": "%s"}`, message)
    })

    fmt.Printf("starting app on port %s\n", port)
    if err := http.ListenAndServe(":"+port, nil); err != nil {
        fmt.Printf("error starting server: %s\n", err)
        os.Exit(1)
    }
}
