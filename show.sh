#!/bin/bash
user="$1"

if [ ! $# -eq 1 ]; then
    echo "Error: parameters problem" >&2
    exit 1
elif [ ! -d "$user" ]; then
    echo "Error: user does not exist" >&2
    exit 1
else
    # Check if we can access the user's wall
    ./P.sh "$user/wall"
        wallOutput="$(cat "$user"/wall)"
        echo -e "wallStart\n$wallOutput\nwallEnd"
    ./V.sh "$user/wall"
    exit 0
fi
