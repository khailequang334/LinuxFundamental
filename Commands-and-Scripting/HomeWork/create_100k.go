package main

import (
	"log"
	"os"
	"strconv"
)

func main() {
	for i := 1; i < 100000; i++ {
		myfile, e := os.Create(strconv.Itoa(i))
		if e != nil {
			log.Fatal(e)
		}
		myfile.Close()
	}
}
