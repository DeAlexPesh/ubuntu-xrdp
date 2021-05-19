#!/bin/bash
test -f /etc/users.list || exit 0
while read id username hash groups; do
 if grep ^$username /etc/passwd; then
  useradd -G $username $username
 else
  addgroup --gid $id $username
  useradd -m -u $id -s /bin/bash -g $username $username
 fi
 echo "$username:$hash" | /usr/sbin/chpasswd -e
 if [ $groups ]; then
  usermod -aG $groups $username
 fi
done < /etc/users.list
