apt-get update
apt-get install lynx -y
apt install speedtest-cli -y

echo "" > /etc/resolv.conf

export http_proxy="http://10.11.2.3:8080"
export PYTHONHTTPSVERIFY=0
