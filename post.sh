#!/bin/bash
receiver="$1"
sender="$2"
msg="$3"

if [ ! $# -eq 3 ]; then
    echo "Error: parameters problem" >&2
    exit 1
elif [ ! -d "$receiver" ]; then
    echo "Error: Receiver does not exist" >&2
    exit 1
elif [ ! -d "$sender" ]; then
    echo "Error: Sender does not exist" >&2
    exit 1
else
    # Check if it's safe to read the friends list to see if posting is permitted
    ./P.sh "$receiver"/friends
        if ! grep -qx "$sender" "$receiver"/friends ; then
            echo "Error: Sender is not a friend of receiver" >&2
            ./V.sh "$receiver"/friends
            exit 1
        else
            # The sender is a friend of the receiver so now we need to check whether we
            # can safely write on the receiver's wall
            ./P.sh "$receiver/wall"
                echo "$sender: $msg" >> "$receiver"/wall
            ./V.sh "$receiver/wall"
            # friends list remains locked until after posting on wall is complete to be safe
            # (i.e., friends list shouldn't be modified during posting on wall to prevent invalid posts from happening)
            ./V.sh "$receiver"/friends
            echo "Ok: Message posted to wall"
            exit 0
        fi
fi
