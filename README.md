# Laporan Resmi Praktikum Modul 3 Jaringan Komputer

Penyelesaian Soal Shift Modul 3 Jaringan Komputer 2022 <br>
Kelompok C03
- Aqil Ramadhan Hadiono - NRP 5025201261
- Christhoper Marcelino Mamahit - NRP 5025201249
- Zahra Fayyadiyati - NRP 5025201133

## Table of Contents
* [Soal 1](#soal-1)
* [Soal 2](#soal-2)
* [Soal 3](#soal-3)
* [Soal 4](#soal-4)
* [Soal 5](#soal-5)
* [Soal 6](#soal-6)
* [Soal 7](#soal-7)
* [Soal 8](#soal-8)
* [Kendala](#kendala)

## Soal 1
**Deskripsi:**
Loid bersama Franky berencana membuat peta tersebut dengan kriteria WISE sebagai DNS Server, Westalis sebagai DHCP Server, Berlint sebagai Proxy Server.

**Pembahasan:**
Atur static IP pada ketiga node tersebut dan install library terkait.
```
Pada Westalis (dhcp server)
apt-get update
apt-get install isc-dhcp-server -y

Pada WISE (dns server)
apt-get update
apt-get install bind9 -y

Pada Berlint (proxy server)
apt-get update
apt-get install squid -y
```


## Soal 2
**Deskripsi:**
Ostania dijadikan sebagai DHCP Relay

**Pembahasan:**
```
Pada Ostania (dhcp relay)
apt-get update
apt-get install isc-dhcp-relay -y
```
Pada /etc/default/isc-dhcp-relay, atur sedemikian rupa
```
SERVERS="10.11.2.4"  # mengarah ke Westalis

INTERFACES="eth1 eth2 eth3"

OPTIONS=""
```

## Soal 3
**Deskripsi:**
Client yang melalui Switch1 mendapatkan range IP dari 10.11.1.50 - 10.11.1.88 dan 10.11.1.120 - 10.11.1.155

**Pembahasan:**
Pada /etc/dhcp/dhcpd.conf, tambahkan
```
subnet 10.11.1.0 netmask 255.255.255.0 {
    range 10.11.1.50 10.11.1.88;
    range 10.11.1.120 10.11.1.155;
    option routers 10.11.1.1;
    option broadcast-address 10.11.1.255;
    option domain-name-servers 10.11.2.2;
    default-lease-time 300;
    max-lease-time 6900;
}
```
Range IP diatur pada baris berikut
```
range 10.11.1.50 10.11.1.88;
range 10.11.1.120 10.11.1.155;
```

## Soal 4
**Deskripsi:**
Client yang melalui Switch3 mendapatkan range IP dari 10.11.3.10 - 10.11.3.30 dan 10.11.3.60 - 10.11.3.85

**Pembahasan:**
Pada /etc/dhcp/dhcpd.conf, tambahkan
```
subnet 10.11.3.0 netmask 255.255.255.0 {
    range 10.11.3.10 10.11.3.30;
    range 10.11.3.60 10.11.3.85;
    option routers 10.11.3.1;
    option broadcast-address 10.11.3.255;
    option domain-name-servers 10.11.2.2;
    default-lease-time 600;
    max-lease-time 6900;
}
```
Range IP diatur pada baris berikut
```
range 10.11.3.10 10.11.3.30;
range 10.11.3.60 10.11.3.85;
```

## Soal 5
**Deskripsi:**
Client mendapatkan DNS dari WISE dan client dapat terhubung dengan internet melalui DNS tersebut.

**Pembahasan:**
Pada /etc/dhcp/dhcpd.conf di Westalis, konfigurasi DNS diatur pada baris berikut
```
option domain-name-servers 10.11.2.2;  # mengarah ke WISE (dns server)
```
Supaya client dapat terhubung ke internet, kita atur supaya WISE mem-forward request ke public internet. Pada /etc/bind/named.conf.options di WISE, aktifkan forwardes dan query sebagai berikut
```
options {
        directory "/var/cache/bind";

        forwarders {
                192.168.122.1;
        };

        //dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
```
Syntax forwarders akan memungkinkan client terhubung ke internet.

## Soal 6
**Deskripsi:**
Lama waktu DHCP server meminjamkan alamat IP kepada Client yang melalui Switch1 selama 5 menit sedangkan pada client yang melalui Switch3 selama 10 menit. Dengan waktu maksimal yang dialokasikan untuk peminjaman alamat IP selama 115 menit. 

**Pembahasan:**
Pada /etc/dhcp/dhcpd.conf, konfigurasi lama peminjaman alamat IP untuk switch1 diatur pada baris berikut
```
default-lease-time 300;
max-lease-time 6900;
```
Sedangkan untuk switch2 diatur sebagai berikut
```
default-lease-time 600;
max-lease-time 6900;
```

## Soal 7
**Deskripsi:**
Loid dan Franky berencana menjadikan Eden sebagai server untuk pertukaran informasi dengan alamat IP yang tetap dengan IP 10.11.3.13 

**Pembahasan:**
Pertama, kita cari dahulu hwaddress Eden dengan command `ip a` dan diperoleh sebagai berikut  
![jarkom1](https://user-images.githubusercontent.com/78243059/201463035-b3840d3d-dd86-4b6f-8bdc-7521c46abf37.png)

Lalu, pada /etc/dhcp/dhcpd.conf, tambahkan konfigurasi di bawah ini 
```
host Eden {
    hardware ethernet 72:91:d4:fa:19:93;  # hwaddress Eden
    fixed-address 10.11.3.13;  # fixed address yang diinginkan
}
```

## Soal 8
### Soal 8.1
**Deskripsi:**
Client hanya dapat mengakses internet diluar (selain) hari & jam kerja (senin-jumat 08.00 - 17.00) dan hari libur (dapat mengakses 24 jam penuh)

**Pembahasan:**
Sebelumnya, pastikan client menjalankan konfigurasi berkut untuk terhubung ke Berlint selaku proxy server.
```
export http_proxy="http://10.11.2.3:8080"
```
Pada Berlint, kita perlu mendefinisikan pengaturan waktu. Konfigurasinya bisa ditaruh di file `/etc/squid/acl.conf`.
```
acl WORKING_HOUR time MTWHF 08:00-17:00
acl OUT_WORKING_HOUR_1 time MTWHF 00:00-08:00
acl OUT_WORKING_HOUR_2 time MTWHF 17:00-24:00
acl WEEKEND time AS 00:00-24:00
```
Pada /etc/squid/squid.conf, kita perlu mengaktifkan pengaturan waktu tersebut.
```
include /etc/squid/acl.conf

http_port 8080
visible_hostname Berlint

http_access deny WORKING_HOUR

http allow all
```


### Soal 8.2
**Deskripsi:**
Adapun pada hari dan jam kerja sesuai nomor (1), client hanya dapat mengakses domain loid-work.com dan franky-work.com (IP tujuan domain dibebaskan)

**Pembahasan:**
Kita perlu mendefinisikan daftar domainnya dahulu. Konfigurasinya bisa ditaruh di file `/etc/squid/company-sites.acl` dan diisi
```
loid-work.com
franky-work.com
```
Konfigurasi ini akan kita inisialisasi sebagi control list pada file `/etc/squid/company-sites.conf` dengan isinya sebagai berikut
```
acl COMPANY_SITES dstdomain "/etc/squid/company-sites.acl"
```
Setelah itu, kita harus mengaktifkannya pada /etc/squid/squid.conf sehingga menjadi berikut
```
http_access deny COMPANY_SITES WEEKEND
http_access deny !COMPANY_SITES WORKING_HOUR
```
Dengan ini, request ke loid-work.com dan franky-work.com akan dilayani pada jam kerja. Kita perlu mengatur tujuan IP nya pada WISE selaku DNS Server. Pada /etc/bind/named.conf.local, kita tambahkan
```
zone "loid-work.com" {
        type master;
        file "/etc/bind/jarkom/loid-work.com";
};

zone "franky-work.com" {
        type master;
        file "/etc/bind/jarkom/franky-work.com";
};
```
Lalu, pada buatlah file /etc/bind/jarkom/loid-work.com dan atur sebagai berikut
```
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
```
Atur juga untuk fanky-work.com pada file /etc/bind/jarkom/franky-work.com
```
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
```
IP dibebaskan sesuai soal. Restart bind9 dan domain akan diarahkan pada IP address yang kita berikan.

### Soal 8.3
**Deskripsi:**
Saat akses internet dibuka, client dilarang untuk mengakses web tanpa HTTPS. (Contoh web HTTP: http://example.com)

**Pembahasan:**
Kita perlu mendefinisikan protocol HTTPS. Konfigurasi ini bisa ditaruh pada file /etc/squid/ssl.conf dan diisi
```
acl SSL_PROTO proto https
```
Lalu, kita perlu mengaktifkan konfigurasi tersebut pada /etc/squid/squid.conf dengan menambahkan syntax di bawah ini pada bagian atas
```
include /etc/squid/ssl.conf
http_access deny !SSL_PROTO
```
Dengan demikian, semua request denagn protocol bukan HTTPS akan ditolak.

### Soal 8.4
**Deskripsi:**
Agar menghemat penggunaan, akses internet dibatasi dengan kecepatan maksimum 128 Kbps pada setiap host (Kbps = kilobit per second; lakukan pengecekan pada tiap host, ketika 2 host akses internet pada saat bersamaan, keduanya mendapatkan speed maksimal yaitu 128 Kbps)

**Pembahasan:**
Definisikan pengaturan pembatasan bandwidth pada file /etc/squid/acl-bandwidth.conf
```
delay_pools 1
delay_class 1 1
delay_access 1 allow all
delay_parameters 1 8000/16000
```
Lalu, aktifkan pada /etc/squid/squid.conf dengan menambahkan syntax tersebut
```
include /etc/squid/acl-bandwidth.conf
```

### Soal 8.5
**Deskripsi:**
Setelah diterapkan, ternyata peraturan nomor (4) mengganggu produktifitas saat hari kerja, dengan demikian pembatasan kecepatan hanya diberlakukan untuk pengaksesan internet pada hari libur

**Pembahasan:**
Untuk melakukan hal itu, kita perlu mengatur ulang definisi pembatasan bandwidth di file /etc/squid/acl-bandwidth.conf. Kita perlu mendefinisikan waktu hari kerja lalu menerapkanny pada delay_access sehingga konfigurasinya akan menjadi dmeikian
```
acl WORK_TIME time MTWHF 08:00-17:00
delay_pools 1
delay_class 1 1
delay_access 1 allow WORK_TIME
delay_parameters 1 8000/16000
```

## Kendala
* Kesusahan dalam mengatur access pada proxy dan adanya tabrakan antara setting permission untuk HTTP dan HTTPS
* Pembatasan bandwith yang terkadang berjalan sesuai deskripsi soal beserta pengaturan waktu pembatasannya
