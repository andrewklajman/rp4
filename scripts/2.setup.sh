LOG=$(date +/root/log/%F_installation.log)

echo "Install required applications" | tee --append $LOG
    apt -y update
    apt -y upgrade
    apt-get -y install ranger neovim curl man doas htop ncdu yt-dlp

echo "Setup doas" | tee --append $LOG
	echo "permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :root" > /etc/doas.conf

# Install NordVpn" | tee --append $LOG
	sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh | sed 's/ASSUME_YES=false/ASSUME_YES=true/g')

	nordvpn login
	echo -n "Please enter callback url: "
	read CALLBACK_URL
	nordvpn login --callback "$CALLBACK_URL"

    nordvpn whitelist add subnet 192.168.0.1/24
    nordvpn set killswitch on
    nordvpn set autoconnect on
    nordvpn set pq on
	nordvpn c switzerland
	nordvpn status

echo "Setup mnt access" | tee --append $LOG
    groupadd mnt_access
	chmod -R 775 /mnt
	chown -R root:mnt_access /mnt

echo "Download and run get-docker script" | tee --append $LOG
    curl -fsSL https://get.docker.com -o get-docker.sh
    bash get-docker.sh
	rm get-docker.sh
	apt-get install -y docker-compose
    docker run hello-world
	docker run --detach --name watchtower --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
