# Notes
#  - https://www.digitalocean.com/community/tutorials/how-to-set-up-squid-proxy-for-private-connections-on-debian-11
#  - turned off authorisation as I wan unable to get it to work with firefox
#  - Remember to create a private profile with firefox
#  - firefox --profile .mozilla/firefox/ytdlkd6k.Secure/ -url https://www.ipleak.net/ -url https://www.nordvpn.com/
#  - tinyproxy: https://nxnjz.net/2019/10/how-to-setup-a-simple-proxy-server-with-tinyproxy-debian-10-buster/

echo "# 7.0.proxyserver.sh"

echo "## Installing"
apt install tinyproxy

echo "## Adding usergroup"
useradd -M -U -s /bin/false tinyproxy

echo "## Creating log"
mkdir -p /mnt/tinyproxy
touch /mnt/tinyproxy/tinyproxy.log
chown tinyproxy:root /mnt/tinyproxy/tinyproxy.log

echo "
##User/Group to use after dropping root
User tinyproxy
Group tinyproxy

##Port and address to bind to
Port 8888
Bind 0.0.0.0

##File locations
DefaultErrorFile "/usr/local/share/tinyproxy/default.html"
StatFile "/usr/local/share/tinyproxy/stats.html"
LogFile "/usr/local/var/log/tinyproxy/tinyproxy.log"
LogLevel Info
PidFile "/var/run/tinyproxy.pid"

##Authentication
BasicAuth your_username your_secure_password

##HTTP Headers
ViaProxyName "server-hostname"
DisableViaHeader No

##Connection
Timeout 600
MaxClients 100
" > /mnt/tinyproxy/tinyproxy.conf

pkill -e tinyproxy

echo "
[Unit]
Description=Tinyproxy daemon
Requires=network.target
After=network.target
After=nordvpnd.service
Requires=nordvpnd.service

[Service]
Type=forking
PIDFile=/var/run/tinyproxy.pid
ExecStart=/usr/local/bin/tinyproxy -c '/mnt/tinyproxy/tinyproxy.conf'
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/tinyproxy.service

systemctl daemon-reload
systemctl start tinyproxy
systemctl stop tinyproxy
systemctl restart tinyproxy
systemctl --now enable tinyproxy.service

#echo "## Installing Squid Proxy"
#apt update
#apt install squid
#
## For implementation of Authorisation
## apt install apache2-utils
## htpasswd -b -c /etc/squid/passwords squid squid
#
#  echo '
#  acl localnet src 0.0.0.1-0.255.255.255	
#  acl localnet src 10.0.0.0/8		
#  acl localnet src 100.64.0.0/10		
#  acl localnet src 169.254.0.0/16 	
#  acl localnet src 172.16.0.0/12		
#  acl localnet src 192.168.0.0/16		
#  acl localnet src fc00::/7       	
#  acl localnet src fe80::/10      	
#  acl SSL_ports port 443
#  acl Safe_ports port 80		
#  acl Safe_ports port 21		
#  acl Safe_ports port 443		
#  acl Safe_ports port 70		
#  acl Safe_ports port 210		
#  acl Safe_ports port 1025-65535	
#  acl Safe_ports port 280		
#  acl Safe_ports port 488		
#  acl Safe_ports port 591		
#  acl Safe_ports port 777		
#  http_access deny !Safe_ports
#  http_access deny CONNECT !SSL_ports
#  http_access allow localhost manager
#  http_access deny manager
#  include /etc/squid/conf.d/*.conf
#
##  # Password protection
##     auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/passwords
##     auth_param basic realm proxy
##     acl authenticated proxy_auth REQUIRED 
##     http_access allow authenticated
##  # Allow traffic from lenovo
##     acl localnet src 192.168.0.209
#
##  http_access allow localhost
##  http_access deny all
#  http_access allow all
#  http_port 3128
#  coredump_dir /var/spool/squid
#  refresh_pattern ^ftp:		1440	20%	10080
#  refresh_pattern ^gopher:	1440	0%	1440
#  refresh_pattern -i (/cgi-bin/|\?) 0	0%	0
#  refresh_pattern .		0	20%	4320
#  visible_hostname rp4
#  ' > /etc/squid/squid.conf
