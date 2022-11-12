echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update
apt-get install bind9 -y

touch ~/shift3/named.conf.options

echo '
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        //dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
}; ' > ~/shift3/named.conf.options

cp ~/shift3/named.conf.options /etc/bind

mkdir /etc/bind/jarkom
touch /etc/bind/jarkom/loid-work.com
touch /etc/bind/jarkom/franky-work.com

echo '
zone "loid-work.com" {
        type master;
        file "/etc/bind/jarkom/loid-work.com";
};

zone "franky-work.com" {
        type master;
        file "/etc/bind/jarkom/franky-work.com";
};
' > /etc/bind/named.conf.local

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     loid-work.com. root.loid-work.com. (
                     2022100601         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      loid-work.com.
@       IN      A       103.94.189.5;
@       IN      AAAA    ::1
' > /etc/bind/jarkom/loid-work.com

echo '
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     franky-work.com. root.franky-work.com. (
                     2022100601         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      franky-work.com.
@       IN      A       216.239.38.120;
@       IN      AAAA    ::1
' > /etc/bind/jarkom/franky-work.com

service bind9 restart