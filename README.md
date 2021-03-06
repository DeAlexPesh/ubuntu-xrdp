## xRDP Terminal service

<pre><code>sudo mkdir -p /app/{images/remote,remote/home/ubuntu} && \
sudo chown 999:999 /app/remote/home/ubuntu && \
cd ~ && \
git clone https://github.com/DeAlexPesh/ubuntu-xrdp.git && \
sudo mv ~/ubuntu-xrdp/Dockerfile /app/images/remote/Dockerfile && \
sudo mv ~/ubuntu-xrdp/bin /app/images/remote/bin && \
sudo mv ~/ubuntu-xrdp/etc /app/images/remote/etc && \
sudo mv ~/ubuntu-xrdp/chrome.json /app/remote/chrome.json && \
sudo mv ~/ubuntu-xrdp/users.list /app/remote/users.list && \
sudo mv ~/ubuntu-xrdp/user-list-gen.sh /app/remote/user-list-gen.sh && \
sudo mv ~/ubuntu-xrdp/extensions /app/remote/extensions && \
rm -rf ~/ubuntu-xrdp && \
sudo chmod -R 775 /app/images/remote/
</code></pre>

<pre>sudo nano /app/remote/users.list

<i>// FORMAT: | id | username | password-hash | list-of-supplemental-groups |
// GET HASH: openssl passwd -1 'PASSWORD'</i>
999 ubuntu $1$PNlonRVV$r4ngGPIFvzT5JGFX1MRs9/ sudo
<i>...</i>
</pre>

<pre><code>sudo chmod +x /app/remote/user-list-gen.sh && \
/app/remote/user-list-gen.sh 10 /app/remote/users.list && \
cat /app/remote/users.list
</code></pre>

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
   - /app/remote/chrome.json:/etc/chromium-browser/policies/managed/chrome.json:ro
   - /app/remote/extensions/:/extensions/:ro
  environment:
   IDLETIME: 0
   KIOSKURL: KIOSKURLREBIND
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

<pre><code>read -er -p 'SiteURI ( ex: https://ya.ru ): ' KIOSKURLREBIND && \
export KIOSKURLREBIND="\"$KIOSKURLREBIND\"" && \
sudo sed -i "s|KIOSKURLREBIND|$KIOSKURLREBIND|" /app/remote/chrome.json && \
sudo sed -i "s|KIOSKURLREBIND|$KIOSKURLREBIND|" /app/compose/remote.yml && \
sudo sed -i "s|KIOSKURLREBIND|$KIOSKURLREBIND|" /app/remote/extensions/navi/script.js && \
unset KIOSKURLREBIND && \
docker-compose -f /app/compose/remote.yml config
</code></pre>

<pre><code>docker-compose -p remote -f /app/compose/remote.yml up -d

</code></pre>

<pre><code>sudo sed -i "4 s|^|#|" /app/compose/remote.yml

</code></pre>
