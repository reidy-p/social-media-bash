#!/bin/bash

if [ ! -p "server.pipe" ]; then
    mkfifo server.pipe
fi

while true; do
    # Use ^ as the delimiter
    IFS="^" read -ra request < server.pipe

    command="${request[0]}"
    clientId="${request[1]}"

    case "$command" in
        create)
            user="${request[2]}"
            ./create.sh "$user" &> "$clientId.pipe" &
            ;;
        add)
            user="${request[2]}"
            friend="${request[3]}"
            ./add.sh "$user" "$friend" &> "$clientId.pipe" &
            ;;
        post)
            receiver="${request[2]}"
            sender="${request[3]}"
            msg="${request[4]}"

            ./post.sh "$receiver" "$sender" "$msg" &> "$clientId.pipe" &
            ;;
        show)
            user="${request[2]}"
            ./show.sh "$user" &> "$clientId.pipe" &
            ;;
        shutdown)
            echo "OK: Shutting down server" > "$clientId.pipe" &
            rm server.pipe
            exit 0
            ;;
        *)
            echo "Error: bad request" &> "$clientId.pipe" &
    esac
done
