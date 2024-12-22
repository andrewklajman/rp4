echo "# 2.setup.sh"

echo "## Kernel and system update"
# I should do some kind of if statement here

apt -y update
KERNEL_RECENT=$( apt-cache search linux-image-[0-9] | grep -v cloud | grep -v rt | grep -v unsigned | grep -v dbg | grep -v headers | sort | tail -n1 | cut -d' ' -f1)
echo "## Update to kernel $KERNEL_RECENT"
apt-get -y install $KERNEL_RECENT cryptsetup
apt -y upgrade
echo "You must reboot for new kernel $(KERNEL_RECENT)to take effect"
read

# Should not be needed after a reboot
#echo "## Bring up encrypted drive"
#apt-get -y install cryptsetup
#cryptsetup luksOpen /dev/sda encrypted_hdd --key-file /root/files/hdd.key
#mount /mnt

echo "## Install required applications"
apt-get -y install ranger neovim curl man doas htop ncdu 

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

# zsh zplug: Zsh is just not practical.  I should learn more if i just want autocompletion
#echo "## Zsh config"
#cp ../files/zshrc /root/.zshrc
#chsh -s /bin/zsh

# Blind access should notbe given
#echo "## Setup mnt access"
#groupadd mnt_access



