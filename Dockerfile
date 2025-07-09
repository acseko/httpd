FROM redhat/ubi9:latest
ENV HTTP_PORT=80
RUN dnf --disableplugin=subscription-manager --assumeyes install openssl jq sed xmlstarlet httpd

COPY docker-entrypoint.sh /

# Smoke test version information
RUN sed -i -e "s/Listen/#Listen/g" /etc/httpd/conf/httpd.conf && \
  echo "Listen \${HTTP_PORT}" > /etc/httpd/conf.d/port.conf && \
  echo "ServerName localhost" >> /etc/httpd/conf.d/port.conf && \
  httpd -v && \
  httpd -M |egrep -h "auth_|ssl" && \
  chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["start"]



