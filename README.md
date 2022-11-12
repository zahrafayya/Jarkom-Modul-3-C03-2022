# Laporan Resmi Praktikum Modul 3 Jaringan Komputer

Penyelesaian Soal Shift Modul 3 Jaringan Komputer 2022 <br>
Kelompok C03

## Table of Contents
* [Soal 1](#soal-1)
* [Soal 2](#soal-2)
* [Soal 3](#soal-3)
* [Soal 4](#soal-4)
* [Soal 5](#soal-5)
* [Soal 6](#soal-6)
* [Soal 7](#soal-7)
* [Soal 8](#soal-8)

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

## Soal 8
### Soal 8.1
**Deskripsi:**
Client hanya dapat mengakses internet diluar (selain) hari & jam kerja (senin-jumat 08.00 - 17.00) dan hari libur (dapat mengakses 24 jam penuh)

**Pembahasan:**

### Soal 8.2
**Deskripsi:**
Adapun pada hari dan jam kerja sesuai nomor (1), client hanya dapat mengakses domain loid-work.com dan franky-work.com (IP tujuan domain dibebaskan)

**Pembahasan:**

### Soal 8.3
**Deskripsi:**
Saat akses internet dibuka, client dilarang untuk mengakses web tanpa HTTPS. (Contoh web HTTP: http://example.com)

**Pembahasan:**

### Soal 8.4
**Deskripsi:**
Agar menghemat penggunaan, akses internet dibatasi dengan kecepatan maksimum 128 Kbps pada setiap host (Kbps = kilobit per second; lakukan pengecekan pada tiap host, ketika 2 host akses internet pada saat bersamaan, keduanya mendapatkan speed maksimal yaitu 128 Kbps)

**Pembahasan:**

### Soal 8.5
**Deskripsi:**
Setelah diterapkan, ternyata peraturan nomor (4) mengganggu produktifitas saat hari kerja, dengan demikian pembatasan kecepatan hanya diberlakukan untuk pengaksesan internet pada hari libur

**Pembahasan:**


