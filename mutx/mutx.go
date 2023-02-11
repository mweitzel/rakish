package main

import (
	//"fmt"
	"net/http"
	"sync"
	"time"
)

var lock sync.Mutex

func main() {
	http.HandleFunc("/", HelloServer)
	http.ListenAndServe(":8988", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
	//fmt.Println("try")
	iOwnLock := lock.TryLock()
	if iOwnLock {
		//fmt.Println("lock acquired, held")
		//_, err := w.Write([]byte("end\n"))
		//w.WriteHeader(200)
		_, err := w.Write([]byte("begin\n"))
		if f, ok := w.(http.Flusher); ok {
			f.Flush()
		}
		if err != nil {
			lock.Unlock()
			return
		}
		select {
		case <-r.Context().Done():
			//fmt.Println("closed early")
		case <-time.After(time.Second * 2):
			//fmt.Println("two seconds")
			_, err = w.Write([]byte("end\n"))
			if err != nil {
				lock.Unlock()
				return
			}
		}

		lock.Unlock()
		//fmt.Println("lock released")
	} else {
		w.WriteHeader(400)
		_, err := w.Write([]byte("end\n"))
		if err != nil {
			//fmt.Println("no lock, end with err")
		}
		//fmt.Println("no lock, end without err")
	}
	//fmt.Println("end no err")
}
