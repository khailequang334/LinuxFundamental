#!/bin/bash
a=$1
b=$2

if [ "$a" \< "$b" ]; then
        echo "$a is smaller then $b"
elif [ "$a" \> "$b" ]; then
        echo "$a is greater than $b"
    else
        echo "$a and $b are equal"
fi