IMAGE="../raspi_4_bookworm.img.xz"

# Extract the image to device
lsblk
echo -n "Please confirm output device: "
read OUTPUT_DEV
xzcat $IMAGE | doas dd of=$OUTPUT_DEV bs=64k oflag=dsync status=progress

# Load image to tmp mount
rm -r /tmp/raspi
mkdir /tmp/raspi
mount "$OUTPUT_DEV"2 /tmp/raspi

# Setup networking
rm /tmp/raspi/etc/network/interfaces.d/eth0
echo "
allow-hotplug wlan0
auto wlan0
iface wlan0 inet static
  address 192.168.0.214
  netmask 255.255.255.0
  gateway 192.168.0.1
wpa-conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf" > /tmp/raspi/etc/network/interfaces.d/wlan0

wpa_passphrase **SSID** **PASSWORD** > /tmp/raspi/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
chmod 0600 /tmp/raspi/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

echo "
update_config=1
ctrl_interface=DIR=/run/wpa_supplicant GROUP=netdev" >> /tmp/raspi/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

echo "
nameserver 1.1.1.1
" >> /tmp/raspi/etc/resolv.conf

# SSH: Update config
echo "PermitRootLogin yes" >> /tmp/raspi/etc/ssh/sshd_config
echo "AddressFamily inet" >> /tmp/raspi/etc/ssh/sshd_config
#sed 's/#Compression.*/Compression yes/g' /tmp/raspi/etc/ssh/sshd_config > /tmp/raspi/etc/ssh/sshd_config_modified
#mv /tmp/raspi/etc/ssh/sshd_config_modified /tmp/raspi/etc/ssh/sshd_config

# SSH: Copy across public ssh key
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMjb+t7vMFkoKa1q/RNrFtrp7RPcAgZLXC6WHIBIQL93 andrew@lenovo" >> /tmp/raspi/root/.ssh/authorized_keys

# Update .bashrc
echo "alias ll='ls --color=auto -l'" >> /tmp/raspi/root/.bashrc
echo "alias lla='ls --color=auto -la'" >> /tmp/raspi/root/.bashrc
echo "alias ip='ip --color'" >> /tmp/raspi/root/.bashrc

# Update hostname
echo "rp4" > /tmp/raspi/etc/hostname

# Copy setup.sh
cp -r ../files/ /tmp/raspi/root
cp -r ../scripts/ /tmp/raspi/root
cp -r ../tools/ /tmp/raspi/root
mkdir /tmp/raspi/root/log

#echo "## Set timezone"
#rm /tmp/raspi/etc/localtime
#ln -s /tmp/raspi/usr/share/zoneinfo/Australia/Sydney /tmp/raspi/etc/localtime

# Update crypttab and fstab
echo "
encrypted_hdd UUID=b22c292e-05f2-487a-a297-f20380b2f6dc /root/files/hdd.key luks
" >> /tmp/raspi/etc/crypttab

echo "
/dev/mapper/encrypted_hdd /mnt ext4 nofail,auto,x-systemd.device-timeout=30 0 2
" >> /tmp/raspi/etc/fstab

# Umount image
umount /tmp/raspi
sleep 5
rmdir /tmp/raspi
