#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Error: parameters problem" >&2
    exit 1
fi

# Check for the special character
for var in "$@"; do
    if [[ "$var" == *"^"* ]]; then
        echo "Error: Special character ^ cannot be used: $var" >&2
        exit 1
    fi
done

if [ ! -p "server.pipe" ]; then
    echo "Error: server is not running" >&2
    exit 1
fi

clientId="$1"
request="$2"

if [ -p "$clientId.pipe" ]; then
    echo "Error: This client ID is currently taken" >&2
    exit 1
else
    mkfifo "$clientId.pipe"
fi

case "$request" in
    create)
        user="$3"
        if [ ! $# -eq 3 ]; then
            echo "Error: create request requires 3 parameters"
            echo "Example: ./client.sh clientId create newUser"
            rm "$clientId".pipe
            exit 1
        elif [ -d "$user" ]; then
            echo "Error: user already exists" >&2
            rm "$clientId".pipe
            exit 1
        else
            ./P.sh server.pipe
                echo "create^$clientId^$user" >> server.pipe
            ./V.sh server.pipe
            read response < "$clientId.pipe"
            echo "$response"
        fi
        ;;
    add)
        user="$3"
        friend="$4"
        if [ ! $# -eq 4 ]; then
            echo "Error: add request requires 4 parameters"
            echo "Example: ./client.sh clientId add user newFriend"
            rm "$clientId".pipe
            exit 1
        elif [ ! -d "$user" ]; then
            echo "Error: user does not exist" >&2
            rm "$clientId".pipe
            exit 1
        elif [ ! -d "$friend" ]; then
            echo "Error: friend does not exist" >&2
            rm "$clientId".pipe
            exit 1
        else
            ./P.sh server.pipe
                echo "add^$clientId^$user^$friend" >> server.pipe
            ./V.sh server.pipe
            read response < "$clientId.pipe"
            echo "$response"
        fi
        ;;
    post)
        receiver="$3"
        sender="$4"
        msg="$5"
        if [ ! $# -eq 5 ]; then
            echo "Error: post request requires 5 parameters"
            echo "Example: ./client.sh clientId post receiver sender msg"
            rm "$clientId".pipe
            exit 1
        elif [ ! -d "$receiver" ]; then
            echo "Error: Receiver does not exist" >&2
            rm "$clientId".pipe
            exit 1
        elif [ ! -d "$sender" ]; then
            echo "Error: Sender does not exist" >&2
            rm "$clientId".pipe
            exit 1
        else
            ./P.sh server.pipe
                echo "post^$clientId^$receiver^$sender^$msg" >> server.pipe
            ./V.sh server.pipe
            read response < "$clientId.pipe"
            echo "$response"
        fi
        ;;
    show)
        user="$3"
        if [ ! $# -eq 3 ]; then
            echo "Error: show request requires 3 parameters"
            echo "Example: ./client.sh clientId show user"
            rm "$clientId".pipe
            exit 1
        elif [ ! -d "$user" ]; then
            echo "Error: user does not exist" >&2
            rm "$clientId".pipe
            exit 1
        else
            ./P.sh server.pipe
                echo "show^$clientId^$user" >> server.pipe
            ./V.sh server.pipe

            # remove wallStart and wallEnd
            cat "$clientId.pipe" | tail -n+2 | head -n -1
        fi
        ;;
    shutdown)
        if [ ! $# -eq 2 ]; then
            echo "Error: shutdown request requires 2 parameters"
            echo "Example: ./client.sh clientId shutdown"
            rm "$clientId".pipe
            exit 1
        else
            ./P.sh server.pipe
                echo "shutdown^$clientId" >> server.pipe
            ./V.sh server.pipe
            read response < "$clientId.pipe"
            echo "$response"
        fi
        ;;
    *)
        echo "Error: bad request"
        rm "$clientId.pipe"
        exit 1
esac

rm "$clientId.pipe"
exit 0
