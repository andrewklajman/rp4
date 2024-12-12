# (Install image onto sd card)[https://raspi.debian.net/how-to-image/]

    $ xzcat 20210408_raspi_3_bullseye.xz | sudo dd of=/dev/{YOUR_DEVICE} bs=64k oflag=dsync status=progress

**Note** By default only vi is installed

# Implmenting Networking

I think that you have to update /etc/network/interfaces.d/wlan0 and make sure that wpa supplicant is turned off (systemd --now disable wpa_supplicant)

# Set up SSH

Update /etc/ssh/sshd_config with the following
    PermitRoolLogin yes
    KbdInteractiveAuthentication yes

Send through public key

Turn on only public key authentication


# Update Debian and Install packages

    apt update
    apt-get install ranger 
    apt-get install neovim 
    apt-get install curl

# Install NordVPN

    sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

once installed run `nordvpn login` and then copy the continue and past in the login

    nordvpn login --callback "nordvpn://login?action=login&exchange_token=NjVjMmNmZjRlMTQ2ZTg3YTZjY2VkNzU3ODczMmJkMTRjMWFhYjU5MzFlZDEyYjI4MmNjODFiM2E5OWFkYmZiOQ%3D%3D&status=done"

Remember to set 

    nordvpn set killswitch 1
    nordvpn set autoconnect 1
    nordvpn set pq 1                # Post quantum
    nordvpn set 
    nordvpn whitelist add subnet 192.168.0.1/24





