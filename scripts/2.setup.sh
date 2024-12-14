echo "# 2.setup.sh"

echo "## Notes:"
echo " - DISPLAY: $DISPLAY"

echo "## Install required applications"
apt -y update
apt -y upgrade
apt-get -y install ranger neovim curl man doas htop ncdu yt-dlp openssh-server chromium xbase-clients

echo "## Setup doas"
echo "permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :root" > /etc/doas.conf

echo "## Install NordVpn"
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

echo "## Setup mnt access"
groupadd mnt_access

echo "## Create SSL Certificate"
mkdir /mnt/ssl
openssl req -nodes -newkey rsa:2048 \
	-keyout /mnt/ssl/ssl.key \
	-out /mnt/ssl/cert.csr \
	-subj "/C=AU/ST=Sydney/L=Sydney/O=Global Security/OU=IT Department/CN=andrewklajman.com"
chmod -R 775 /mnt
chown -R root:mnt_access /mnt

echo "## Download and run get-docker script"
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
rm get-docker.sh
apt-get install -y docker-compose
docker run hello-world
docker run --detach --name watchtower --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

echo "## rebooting system"
reboot

