## xRDP Terminal service

<pre><code>sudo mkdir -p /app/{images/remote,remote/home/ubuntu} && \
sudo chown 999:999 /app/remote/home/ubuntu && \
cd ~ && \
git clone https://github.com/DeAlexPesh/ubuntu-xrdp.git && \
sudo mv ~/ubuntu-xrdp/Dockerfile /app/images/remote/Dockerfile && \
sudo mv ~/ubuntu-xrdp/bin /app/images/remote/bin && \
sudo mv ~/ubuntu-xrdp/etc /app/images/remote/etc && \
sudo mv ~/ubuntu-xrdp/users.list /app/remote/users.list && \
rm -rf ~/ubuntu-xrdp && \
sudo chmod -R 775 /app/images/remote/
</code></pre>

<pre>sudo nano /app/remote/users.list

<i>// FORMAT: | id | username | password-hash | list-of-supplemental-groups |
// GET HASH: openssl passwd -1 'PASSWORD'</i>
1001 link01 $1$ikxogJPH$8/8cRkq7T94Fjt4OVWncU1 sudo
1002 link02 $1$uLaqZlMF$zY7//SH5NZlWnRMFM6Ni1/ sudo
<i>...
N linkN</i>
</pre>

<pre><code>sudo bash -c 'cat &lt;&lt;EOT > /app/compose/remote.yml
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
   IDLETIME: 1
  network_mode: bridge
  logging:
   driver: "json-file"
   options:
    max-size: "200k"
    max-file: "5"
  restart: always
EOT' && \
docker-compose -f /app/compose/remote.yml config
</code></pre>

<pre><code>docker-compose -p remote -f /app/compose/remote.yml up -d

</code></pre>

<pre><code>sudo sed -i "4 s|^|#|" /app/compose/remote.yml

</code></pre>
