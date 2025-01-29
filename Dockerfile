FROM redhat/ubi9:latest

RUN dnf --disableplugin=subscription-manager --assumeyes install openssl jq sed xmlstarlet mod_ssl mod_auth_openidc mod_auth_gssapi httpd
# Smoke test version information
RUN httpd -v && \
  httpd -M |egrep -h "auth_|ssl"


