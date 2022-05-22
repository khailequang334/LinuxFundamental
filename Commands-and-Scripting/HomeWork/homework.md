Ex1: 
xargs   : (eXtended ARGumentS) is a command used to build and execute commands from standard input. 
		  It converts input from standard input into arguments to a command.
Options : 
-n max-args     : Use at most max-args arguments per  command  line, default is 1.
-P max-procs    : Run up to max-procs processes at a time; default is 1. If max-procs is 0, xargs will run as 
				  many processes as possible at a time.
-I replace-str  : Replace occurrences of replace-str in the initial arguments with names read from standard input.

Explain commands: # ls removed* | xargs rm -vf
(*) ls removed*     : List all files start with "removed" in current directory.
(*) pipe "|"        : Connects stdout of before command to stdin of after command.
(*) xargs rm -vf    : By default xargs runs with -n1 -P1, so commands will remove items one by one and sequentialy.

Explain commands: find /var/log -type f -name "*nginx*" | xargs -I{} -n1 -P8 rm -vf {}
(*) find /var/log -type f -name "*nginx*"   : Find all standard files contain "nginx" in their names.
(*) pipe "|"                                : Connects stdout of before command to stdin of after command.
(*) xargs -I{} -n1 -P8 rm -vf {}          	: One item will replace '{}' in command (-n1). Commands will run to 
											  remove in paralel with maximum 8 processes (-P8).

Ex2:
Create 100.000 file:
BASH: 
$ time for i in {1..100000}; do echo "" > "$i.txt"; done
real    0m2.156s
user    0m0.613s
sys     0m1.538s

PYTHON  :
'create_100k.py':
import os
for i in range(1, 100000):
    f = open("%i.txt" %i, 'w')
    f.close()

$ time python3 create_100k.py
real    0m1.362s
user    0m0.539s
sys     0m0.819s


Ex3:
String comparison in bash base on ASCII alphabetical order. 
Bash string comparison uses strcmp() C function internally. 

'compare_string':
#!/bin/bash
a=$1
b=$2

if [ "$a" \< "$b" ]; then
        echo "$a is smaller then $b"
elif [ "$a" \> "$b" ]; then
        echo "$b is smaller than $a"
    else
        echo "$a and $b are equal"
fi

Ex4:
1/ Print the name of all users in the system (Hint: /etc/passwd)
$ awk -F: '{print $1}' /etc/passwd
Explain: Get content of /etc/passwd, separate data fields by ":" then print out the 1st field/

2/ Check to see if python is installed in your server, what's its version?
$ python3 --version
$ Python 3.8.2

3/ Find and remove all directories named "remove_me" inside /tmp
$ find /tmp/ -type d -name "remove_me" | xargs rmdir -v
Explain: find all directories (d) named "remove_me" int /tmp/, then use xargs to pass these item to command 
		 rmdir (-v for print log)

4/ How many processes named "xxx" are running in the system? (Hint: ps aux)
$ ps -C "xxx" | awk '(NR>1)' | wc -l
$ ps -C "xxx" | tail +2 | wc -l
Explain: Get information of processes named "xxx" showing line by line, then skip the header line and count.

$ ps aux | grep "xxx" | wc -l 
Explain: Get all information of processes line by line, then filter name by "grep" and count.

5/ Rename all *.txt inside a folder into *.text
$ find 'folder-dir' -type f -name "*.txt" | xargs basename -s .txt | xargs -I{} mv "{}.txt" "{}.text"
Explain: find all file end with ".txt" then pass them to "basename" command with option -s to get file name 
		 without ".txt" suffix. Use "mv" command to change file name. 

6/ Remove all files named "xxx" and contains "Shitty stuff" in /tmp
$ find /tmp -type f -name "xxx" | xargs grep -l "Shitty stuff" | xargs rm -vf
Explain: search all files named "xxx" then filter to get only files contain "Shitty stuff" in directory,
         then pass them to rm command to remove.

/7 Given a http log file, print all the lines containing bad status codes (>399)
$ cat 'dir to access.log' | awk '($8 > 399)'
Explain: Get content of access.log then filter get lines have '8th data field' (status code) greater than 399.

/8 Given a http log file, find the most accessed urls, get the total number of accesses on top 5 urls
$ awk '{print $10}' 'log file dir' | sort | uniq -cd | sort -nr | head -5
Explain:
(*) get 10th-data-field (url) from log file
(*) sort and get unique with count of duplicate
(*) numberic(-n) sort and revert(-r) to get result in descending order
(*) get the first 5 lines of result.

/9 Create ./check_process.sh PID [interval]
'check_pid.sh':
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
