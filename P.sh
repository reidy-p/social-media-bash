#! /bin/bash
user="$1"

if [ -z "$user" ]; then
    echo "Usage $0 mutex-name"
    exit 1
else
    while ! ln "$0" "$user-lock" 2> /dev/null; do
        sleep 1
    done
    exit 0
fi
