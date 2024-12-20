echo "# 2.1.externanal_hdd.sh"

echo "## Install cryptsetup"
apt-get -y install cryptsetup

#echo "## Create drive"
#cryptsetup luksFormat $DEVICE --key-file $KEY_FILE
#cryptsetup luksOpen $DEVICE external_hdd --key-file $KEY_FILE
#mkfs.ext4 /dev/mapper/external_hdd

echo "## Update crypttab and fstab"
echo "
encrypted_hdd 7178a515-5b2e-45bb-a675-d16d54750190 /root/files/hdd.key luks
" >> /etc/crypttab

echo "
/dev/mapper/encrypted_hdd /mnt ext4 nofail,auto,x-systemd.device-timeout=30 0 2
" >> /etc/fstab
