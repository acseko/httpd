#create random ports
HTTP_PORTS=$(comm -23 <(seq 1025 20000 |sort -u) <(ss -Htan |awk '{print $4}' |cut -d ':' -f 2 |sort -u) |shuf |head -n 1)
echo "<h1>hello on port: ${HTTP_PORTS}</h1>" >./index.html
podman run --rm --init -d --name test-${HTTP_PORTS} --network host -e HTTP_PORT=127.0.0.1:${HTTP_PORTS} -v ./index.html:/var/www/html/index.html localhost/httpd
sleep 3
curl -v http://localhost:${HTTP_PORTS}/index.html
podman stop test-${HTTP_PORTS}
