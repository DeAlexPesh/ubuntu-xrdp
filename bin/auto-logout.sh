#!/bin/sh
if [ "$IDLETIME" ]; then xautolock -time "$IDLETIME" -locker pkill -u "$USER"; fi
# ncat -l -p 5555 --allow 127.0.0.1 -e pkill -u "$USER"
