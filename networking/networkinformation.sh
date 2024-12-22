rm $1

echo "# ip route list" >> $1
ip route list >> $1
echo "" >> $1
echo "" >> $1

echo "# ip address" >> $1
ip address >> $1
echo "" >> $1
echo "" >> $1

echo "# iptables -L" >> $1
iptables -L >> $1
echo "" >> $1
echo "" >> $1

echo "# NordVPN status" >> $1
nordvpn status >> $1
echo "" >> $1
echo "" >> $1

echo "# NordVPN settings" >> $1
nordvpn status >> $1
echo "" >> $1
echo "" >> $1

echo "# Tailscale status" >> $1
tailscale status >> $1
echo "" >> $1
echo "" >> $1
