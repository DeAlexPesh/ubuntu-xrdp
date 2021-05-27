#!/bin/bash

displays=$(ps aux | grep Xvnc | grep -v 'grep\|sed' | sed -r 's|.*(Xvnc :[0-9]*).*|\1|' | cut -d' ' -f 2)

while read -r d; do
  export DISPLAY=$d
  idle=$(xprintidle)

  if ! [ "$idle" -eq "$idle" ] 2>/dev/null; then exit; fi

  idleMins=$((idle/1000/60))
  if [[ $idleMins -gt "$IDLETIME" ]]; then
    PID=$(pgrep -f "vnc $d")
    kill -HUP "$PID"
    
    FNAME=$(echo $d | sed -e 's/:/X/g')
    FILENAME="/tmp/.X11-unix/$FNAME"
    rm -f "$FILENAME"
  fi  
done <<< "$displays"
