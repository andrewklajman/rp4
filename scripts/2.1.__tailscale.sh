# https://tailscale.com/kb/1174/install-debian-bookworm

echo "# 2.1.tailscale.sh"

echo "## Adding keys"
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list

echo "## Intall"
apt-get update
apt-get install tailscale

echo "## Updateing NordVPN"
nordvpn whitelist add port 41641 protocol udp

echo "## Raising"
tailscale up





