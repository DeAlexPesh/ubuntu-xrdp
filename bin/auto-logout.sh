#!/bin/sh
if [ "$IDLETIME" ]; then xautolock -time "$IDLETIME" -locker pkill -u "$USER"; fi
while true; do { printf 'HTTP/1.1 200 OK\r\n'; sh pkill -u "$USER"; } | nc -l 8080; done
