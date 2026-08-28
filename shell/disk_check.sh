#!/bin/bash

THRESHOLD=80

df -h | awk 'NR>1 {print $5, $6}' | while read usage mount
do
    usage=${usage%\%}

    if [ "$usage" -ge "$THRESHOLD" ]; then
        echo "WARNING: $mount is ${usage}% full"
    else
        echo "OK: $mount is ${usage}% full"
    fi
done
