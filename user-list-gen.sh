#!/bin/bash

if [[ $# -eq 0 ]]; then
 printf '\nUsage: user-list-gen.sh X Y  ( X is need users quantity, Y is users.list file... )\n\n'
 exit 0
fi

echo '' > "$2"

for (( I=1; I<="$1"; I++ )); do  
 NMUSER=$(printf "link%02d" $I)
 echo "$((1000+I)) $NMUSER $(openssl passwd -1 "$NMUSER") sudo" >> "$2"
done
