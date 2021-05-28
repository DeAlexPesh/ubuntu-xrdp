#!/bin/bash
while true; do
 if [[ "$(xprintidle)" -gt "$IDLETIME" ]]; then pkill -u "$USER"; fi
done
