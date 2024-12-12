IMAGE="../raspi_4_bookworm.img.xz"

# Extract the image to device
	lsblk
	echo -n "Please confirm output device: "
	read OUTPUT_DEV
	xzcat $IMAGE | doas dd of=$OUTPUT_DEV bs=64k oflag=dsync status=progress

# Load image to tmp mount
	mkdir /tmp/raspi
	mount "$OUTPUT_DEV"2 /tmp/raspi

# Setup networking
	rm /tmp/raspi/etc/network/interfaces.d/eth0
	echo "
	allow-hotplug wlan0
	auto wlan0
	iface wlan0 inet dhcp
	wpa-conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf" > /tmp/raspi/etc/network/interfaces.d/wlan0
	
	wpa_passphrase Optus_C99CB5 hinds25536kr > /tmp/raspi/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
	chmod 0600 /tmp/raspi/etc/wpa_supplicant/wpa_supplicant-wlan0.conf
	
	echo "
	update_config=1
	ctrl_interface=DIR=/run/wpa_supplicant GROUP=netdev" >> /tmp/raspi/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

# SSH: Allow root login
	echo "PermitRootLogin yes" >> /tmp/raspi/etc/ssh/sshd_config

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

# Umount image
	umount /tmp/raspi
	rmdir /tmp/raspi
