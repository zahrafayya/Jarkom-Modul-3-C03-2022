echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install isc-dhcp-server -y

touch ~/shift3/dhcpd.conf

echo '
ddns-update-style none;

option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

log-facility local7;

subnet 10.11.2.0 netmask 255.255.255.0 {
    option routers 10.11.2.1;
}

subnet 10.11.1.0 netmask 255.255.255.0 {
    range 10.11.1.50 10.11.1.88;
    range 10.11.1.120 10.11.1.155;
    option routers 10.11.1.1;
    option broadcast-address 10.11.1.255;
    option domain-name-servers 10.11.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}

subnet 10.11.3.0 netmask 255.255.255.0 {
    range 10.11.3.10 10.11.3.30;
    range 10.11.3.60 10.11.3.85;
    option routers 10.11.3.1;
    option broadcast-address 10.11.3.255;
    option domain-name-servers 10.11.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}

host Eden {
    hardware ethernet 86:7b:07:02:46:04;
    fixed-address 10.11.3.13;
}
' > ~/shift3/dhcpd.conf

cp ~/shift3/dhcpd.conf /etc/dhcp
service isc-dhcp-server restart