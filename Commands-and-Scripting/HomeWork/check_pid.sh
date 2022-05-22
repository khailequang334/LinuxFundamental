#!/bin/bash
n=0
pid=$1
itv=$2
while true; 
do  
    n=$(ps -p 1 | tail +2 | wc -l)
    if[ $n -lt 1 ]
    then 
        echo "pid $pid is unavailable"
		mail -s "PID check alert" somebody@example.com <<< "Proces PID $pid is unavailable!"
    fi
    sleep $itv
done
