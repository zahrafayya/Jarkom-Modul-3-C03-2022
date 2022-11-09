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

service bind9 restart