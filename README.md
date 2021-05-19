<pre>
-------
xRDP Terminal service
-------

sudo mkdir -p /app/{images/remote,remote/home/ubuntu} && \
sudo chown 999:999 /app/remote/home/ubuntu && \
cd ~ && \
sudo git clone https://github.com/DeAlexPesh/ubuntu-xrdp.git && \
sudo mv ~/ubuntu-xrdp/Dockerfile /app/images/remote/Dockerfile && \
sudo mv ~/ubuntu-xrdp/bin /app/images/remote/bin && \
sudo mv ~/ubuntu-xrdp/etc /app/images/remote/etc && \
sudo mv ~/ubuntu-xrdp/users.list /app/remote/users.list && \
sudo rm -rf ~/ubuntu-xrdp

sudo nano /app/remote/users.list
// FORMAT: | id | username | password-hash | list-of-supplemental-groups |
// GET HASH: openssl passwd -1 'PASSWORD'
1001 link01 $1$ikxogJPH$8/8cRkq7T94Fjt4OVWncU1 sudo
1002 link02 $1$uLaqZlMF$zY7//SH5NZlWnRMFM6Ni1/ sudo
...
N linkN


sudo bash -c 'cat \<\<EOT > /app/compose/remote.yml
version: "3.5"
services:
 remote: 
  build: /app/images/remote
  image: images/remote:mode
  container_name: "remote"
  hostname: remote
  shm_size: 1g
  ports:
   - "3389:3389"
  volumes:
   - /app/remote/home/:/home/
   - /app/remote/users.list:/etc/users.list:ro
  environment:
   IDLETIME: 11
  network_mode: bridge
  logging:
   driver: "json-file"
   options:
    max-size: "200k"
    max-file: "5"
  restart: always
EOT' && \
docker-compose -f /app/compose/remote.yml config
docker-compose -p vnc -f /app/compose/remote.yml up -d

sudo sed -i "4 s|^|#|" /app/compose/remote.yml
</pre>
