echo nameserver 192.168.122.1 > /etc/resolv.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.11.0.0/16
apt-get update
apt-get install isc-dhcp-relay -y

echo '
SERVERS="10.11.2.4"

INTERFACES="eth1 eth2 eth3"

OPTIONS=""' > /etc/default/isc-dhcp-relay

service isc-dhcp-relay restart