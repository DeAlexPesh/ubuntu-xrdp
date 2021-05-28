#!/bin/bash
while true; do
 IDLE=$(xprintidle)
 if [ "$IDLE" -gt "$IDLETIME" ]; then pkill -u "$USER"; fi
done
