FROM redhat/ubi9:latest

RUN dnf --disableplugin=subscription-manager --assumeyes install openssl jq sed xmlstarlet mod_ssl mod_auth_openidc mod_auth_gssapi httpd
# Smoke test version information
RUN httpd -v && \
  httpd -M |egrep -h "auth_|ssl" && \
  FROM=1025 && \
  TO=32000 && \
  HOWMANY=1 && \
  LISTEN_PORT=$(comm -23 \
  <(seq "$FROM" "$TO" | sort) \
  <(ss -Htan | awk '{print $4}' | cut -d':' -f2 | sort -u) \
  | shuf | head -n "$HOWMANY") && \
  echo "Listen $LISTEN_PORT" > /etc/httpd/conf.d/port.conf && \
  echo "ServerName localhost" >> /etc/httpd/conf.d/port.conf && \
  cat /etc/httpd/conf.d/port.conf

ENTRYPOINT ["/usr/sbin/httpd", "-k", "start"]
