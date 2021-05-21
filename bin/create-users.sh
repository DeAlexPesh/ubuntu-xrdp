#!/bin/bash

test -f /etc/users.list || exit 0

while read -r id username hash groups; do
 # --- skip comments and blank lines
 if [[ -z "$id" && "$id" == [[:blank:]#]* ]]; then continue; fi
 
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
  usermod -aG "$groups" "$username"
 fi
done < /etc/users.list
