# Notes
# 	- Available on port 8080
# 	- Logs available from .local/share/qBittorrent/logs

# Create user
    useradd \
    	--create-home \
    	--shell /bin/bash \
    	--password $(echo password | openssl passwd -1 -stdin) \
		--groups mnt_access
    	torrent

# Install qbittorrent_nox
    apt -y update
    apt -y upgrade
    apt-get -y install qbittorrent-nox

# Run program in background to generate configs
    echo y | doas -u torrent qbittorrent-nox &
    sleep 1
    kill $(ps aux | grep 'qbittorrent-nox' | awk '{print $2}')

# Copy across configuration
    cp ./files/qBittorrent.conf /home/torrent/.config/qBittorrent/
	
# Create folders
    mkdir /mnt/qbittorrent-nox
    mkdir /mnt/qbittorrent-nox/incomplete_torrent
	chmod -R root:mnt_access /mnt
	chown -R 774 /mnt

# Setup auto run
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

