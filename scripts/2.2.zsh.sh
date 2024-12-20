# https://wiki.debian.org/Zsh
echo "# 2.2.zsh.sh"

echo "## Install"
apt install zsh zplug

echo "## Implement config"
cp ../files/zshrc /root/.zshrc

echo "## Update default shell"
chsh -s /bin/zsh

