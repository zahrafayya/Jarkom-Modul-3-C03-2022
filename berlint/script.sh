echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install squid -y

touch /etc/squid/allowed-sites.acl

echo '
loid-work.com
franky-work.com
' > /etc/squid/allowed-sites.acl

touch /etc/squid/acl.conf

echo '
acl WORKING_HOUR time MTWHF 08:00-17:00
' > /etc/squid/acl.conf

echo '
#include /etc/squid/acl.conf
#include /etc/squid/ssl.conf

#acl COMPANY_SITES dstdomain "/etc/squid/allowed-sites.acl"
#acl COMPANY_SITES dstdomain loid-work.com franky-work.com

http_port 8080
visible_hostname Berlint

http_access deny !SSL_PORT

#http_access allow COMPANY_SITES !WORKING_HOUR

#http_access allow all

#include /etc/squid/acl-bandwidth.conf
' > /etc.squid/squid.conf

service squid restart