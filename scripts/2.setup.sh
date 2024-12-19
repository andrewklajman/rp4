echo "# 2.setup.sh"

echo "## Have you installed the latest kernel?"
KERNEL_RECENT=$(apt-cache search linux-image-[0-9] | grep -v cloud | grep -v rt | grep -v unsigned | grep -v dbg | grep
-v headers | sort | tail -n1)
echo "  - The most recent kernel package is $KERNEL_RECENT"
read

echo "## Install required applications"
apt -y update
apt -y upgrade
apt-get -y install ranger neovim curl man doas htop ncdu yt-dlp

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

echo "## Download and run get-docker script"
curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
rm get-docker.sh
apt-get install -y docker-compose
docker run hello-world
docker run --detach --name watchtower --volume /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

echo "## Only allow docker to run after mnt.service has run"
sed 's/\[Unit\]/[Unit]\nAfter=mnt.mount\nRequires=mnt.mount/' /usr/lib/systemd/system/docker.service > docker.service.modified
mv docker.service.modified /usr/lib/systemd/system/docker.service
systemd daemon-reload

echo "## Update  timezone"
timedatectl set-timezone Australia/Sydney



