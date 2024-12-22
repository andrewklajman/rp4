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

echo "## Updating configuration"
echo '
##User/Group to use after dropping root
User tinyproxy
Group tinyproxy

##Port and address to bind to
Port 8888
Bind 0.0.0.0

##File locations
DefaultErrorFile "/usr/share/tinyproxy/default.html"
StatFile "/usr/share/tinyproxy/stats.html"
LogFile "/mnt/tinyproxy/tinyproxy.log"
LogLevel Info
PidFile "/var/run/tinyproxy.pid"

###Authentication
#BasicAuth tiny proxy

##HTTP Headers
ViaProxyName "rp4"
DisableViaHeader No

##Connection
Timeout 600
MaxClients 100

' > /mnt/tinyproxy/tinyproxy.conf


echo "
[Unit]
Description=Tinyproxy daemon
After=network.target
Requires=network.target
After=nordvpnd.service
Requires=nordvpnd.service
After=mnt.mount
Requires=mnt.mount

[Service]
Type=forking
PIDFile=/var/run/tinyproxy.pid
ExecStart=/usr/bin/tinyproxy -c '/mnt/tinyproxy/tinyproxy.conf'
Restart=on-failure

[Install]
WantedBy=multi-user.target
" > /etc/systemd/system/tinyproxy.service

echo "## Creating log"
[ -d "/mnt/tinyproxy" ] && mkdir -p /mnt/tinyproxy
touch /mnt/tinyproxy/tinyproxy.log
chmod 775 /mnt/tinyproxy/tinyproxy.log
chown -R tinyproxy:tinyproxy /mnt/tinyproxy

pkill -e tinyproxy
systemctl daemon-reload
systemctl --now enable tinyproxy.service

