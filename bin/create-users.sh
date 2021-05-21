#!/bin/bash

[ -f /etc/users.list ] || exit 0

while read -r id username hash groups; do
 # --- skip comments and blank lines
 [[ -z "$id" || "$id" == [[:blank:]#]* ]] && continue
 
 # --- if user not exists
 if ! grep ^"$username" /etc/passwd >/dev/null; then
  # --- create group
  addgroup --gid "$id" "$username"
  # --- create user
  useradd -m -u "$id" -s /bin/bash -g "$username" "$username"
 # --- if user already exists
 else
  # --- reset user groups list
  usermod -G "$username" "$username"
 fi
 # --- change user hashword
 usermod -p "$hash" "$username"
 # --- add user in supplementary groups
 if [ "$groups" ]; then
  readarray -d , -t strarr <<<"$groups"
  for (( n=0; n < ${#strarr[*]}; n++ )); do
   [ "$(getent group "${strarr[n]}")" ] && usermod -aG "${strarr[n]}" "$username"
  done
 fi
done < /etc/users.list
