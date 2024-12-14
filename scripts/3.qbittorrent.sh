echo "# 3.qbittorrent.sh"

echo "
## Notes
	- Available on port 8080
	- Logs available from .local/share/qBittorrent/logs
"
echo " - DISPLAY: $DISPLAY"

echo "## Create user"
useradd \
	--create-home \
	--shell /bin/bash \
	--password $(echo password | openssl passwd -1 -stdin) \
	--groups mnt_access \
	torrent

echo "## Install qbittorrent_nox"
apt -y update
apt -y upgrade
apt-get -y install qbittorrent-nox

echo "## Run program in background to generate configs"
echo y | doas -u torrent qbittorrent-nox &
sleep 5
kill $(ps aux | grep 'qbittorrent-nox' | awk '{print $2}')

echo "## Copy across configuration"
cp ../files/qBittorrent.conf /home/torrent/.config/qBittorrent/
	
echo "## Create folders"
mkdir /mnt/qbittorrent-nox
mkdir /mnt/qbittorrent-nox/complete
mkdir /mnt/qbittorrent-nox/incomplete
mkdir /mnt/qbittorrent-nox/scripts
cp ../files/torrent_finished.sh /mnt/qbitt0rrent-nox/scripts
chmod -R 775 /mnt
chown -R root:mnt_access /mnt

echo "## Setup auto run"
echo "
[Unit]
Description=Qbittorrent Daemon
After=nordvpnd.service

[Service]
ExecStart=/usr/bin/qbittorrent-nox
NonBlocking=true
KillMode=process
Restart=on-failure
RestartSec=5
#RuntimeDirectoryMode=0750
User=torrent

[Install]
WantedBy=default.target" > /etc/systemd/system/qbittorrent-nox.service

systemctl --now enable qbittorrent-nox.service

apt -y autoremove
reboot
