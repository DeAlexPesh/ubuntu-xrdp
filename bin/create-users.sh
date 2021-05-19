#!/bin/bash

test -f /etc/users.list || exit 0
while read -r id username hash groups; do
 if [ -z "$username" ]; then continue; fi
 if ! grep ^"$username" /etc/passwd >/dev/null; then
  addgroup --gid "$id" "$username"
  useradd -m -u "$id" -s /bin/bash -g "$username" "$username"
 else
  usermod -G "$username" "$username"
 fi
 echo "$username:$hash" | /usr/sbin/chpasswd -e
 if [ "$groups" ]; then
  usermod -aG "$groups" "$username"
 fi
done < /etc/users.list
