#!/bin/sh
if [ $IDLETIME ]; then
 xautolock -time $IDLETIME -locker openbox --exit
elif [ $LOCKTIME ]; then
 xautolock -time $LOCKTIME -locker slock
else
 xautolock -time 10 -locker slock
fi
