#! /bin/bash
user="$1"

if [ -z "$user" ]; then
    echo "Usage $user mutex-name"
    exit 1
else
    rm "$user-lock"
    exit 0
fi
