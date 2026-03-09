#create random ports
HTTP_PORTS=$(comm -23 <(seq 1025 20000 |sort -u) <(ss -Htan |awk '{print $4}' |cut -d ':' -f 2 |sort -u) |shuf |head -n 1)
echo "<h1>${HTTP_PORTS}" >./index.html
podman run --rm -it --network host --env HTTP_PORT=127.0.0.1:${HTTP_PORTS} -v ./index.html:/var/www/html/index.html localhost/httpd
curl -v http://localhost:${HTTP_PORTS}/index.html
