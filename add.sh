#!/bin/bash
user="$1"
friend="$2"

if [ ! $# -eq 2 ]; then
    echo "Error: parameters problem" >&2
    exit 1
elif [ ! -d "$user" ]; then
    echo "Error: user does not exist" >&2
    exit 1
elif [ ! -d "$friend" ]; then
    echo "Error: friend does not exist" >&2
    exit 1
else
    # Check whether we can access friends
    ./P.sh "$user/friends"
        if ! grep -qx "$friend" "$user/friends" ; then
            echo "$friend" >> "$user/friends"
            echo "OK: friend added"
            ./V.sh "$user/friends"
            exit 0
        else
            echo "Error: user already friends with this user" >&2
            ./V.sh "$user/friends"
            exit 1
        fi
fi
