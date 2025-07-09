/usr/bin/httpd -k $1
tail -f /var/log/httpd/error_log --pid=$(cat /run/httpd/httpd.pid)
