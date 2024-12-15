echo "# 2.setup.sh"

echo "## Notes:"
echo " - DISPLAY: $DISPLAY"

echo "## Install required applications"
apt -y update
apt -y upgrade
apt-get -y install ranger neovim curl man doas htop ncdu yt-dlp
echo " - DISPLAY: $DISPLAY"

echo "## Setup doas"
echo "permit setenv {PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin} :root" > /etc/doas.conf
echo " - DISPLAY: $DISPLAY"

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
echo " - DISPLAY: $DISPLAY"

echo "## Setup mnt access"
groupadd mnt_access
echo " - DISPLAY: $DISPLAY"

echo "## Download and run get-docker script"
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
rm get-docker.sh
apt-get install -y docker-compose
docker run hello-world
docker run --detach --name watchtower --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
echo " - DISPLAY: $DISPLAY"

echo "## Install chromium"
useradd \
	--create-home \
	--shell /bin/bash \
	--password $(echo password | openssl passwd -1 -stdin) \
	chromium
cp -r /root/.ssh /home/chromium
chown -R chromium:chromium /home/chromium/.ssh
apt-get -y install chromium
echo " - DISPLAY: $DISPLAY"

echo "## rebooting system"
apt -y autoremove
reboot

