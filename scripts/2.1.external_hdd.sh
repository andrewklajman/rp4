echo "# 2.1.externanal_hdd.sh"

echo "## Install cryptsetup"
apt-get -y install cryptsetup

lsblk
echo -n "Please confirm device: "
read DEVICE

KEY_FILE="/root/files/hdd.key"

echo "## Create drive"
cryptsetup luksFormat $DEVICE --key-file $KEY_FILE
cryptsetup luksOpen $DEVICE external_hdd --key-file $KEY_FILE
mkfs.ext4 /dev/mapper/external_hdd

UUID=$(blkid | grep $DEVICE | cut -d' ' -f2)
echo "
encrypted_hdd $UUID $KEY_FILE luks
" >> /etc/crypttab

echo "
/dev/mapper/encrypted_hdd /mnt ext4 nofail,auto,x-systemd.device-timeout=30 0 2
" >> /etc/fstab
