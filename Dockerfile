FROM redhat/ubi10:latest
ENV HTTP_PORT=8080
RUN dnf --disableplugin=subscription-manager --assumeyes install openssl jq sed xmlstarlet httpd mod_auth_gssapi mod_auth_openidc

# Smoke test version information
RUN sed -i -e "s/Listen/#Listen/g" /etc/httpd/conf/httpd.conf && \
  echo "Listen \${HTTP_PORT}" > /etc/httpd/conf.d/port.conf && \
  echo "ServerName localhost" >> /etc/httpd/conf.d/port.conf && \
  httpd -v && \
  httpd -M |egrep -h "auth_|ssl"

ENTRYPOINT ["/usr/sbin/httpd", "-DFOREGROUND", "-k"]
CMD ["start"]
