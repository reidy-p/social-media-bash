#!/bin/bash
user="$1"

if [ ! $# -eq 1 ]; then
    echo "Error: parameters problem" >&2
    exit 1
elif [ -d "$user" ]; then
    echo "Error: user already exists" >&2
    exit 1
else
    # If two clients try to create the same user at the same time, one will have
    # to wait for the other to finish
    ./P.sh "$user"
        if [ ! -d "$user" ]; then
            mkdir "$user"
            touch "$user"/friends
            touch "$user"/wall
            echo "OK: user created"
            ./V.sh "$user"
            exit 0
        else
            echo "Error: user already exists" >&2
            ./V.sh "$user"
            exit 1
        fi
fi
