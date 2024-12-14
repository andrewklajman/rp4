echo "# 4.audiobookshelf.sh"
echo " - DISPLAY: $DISPLAY"

echo "## Notes
  - http://192.168.0.214:8096/web/
  - Credentials: jellyfin, jellyfin
"

echo "## Creating folders" | tee --append $LOG
mkdir /mnt/jellyfin
mkdir /mnt/jellyfin/movies
chmod -R 775 /mnt
chown -R root:mnt_access /mnt

echo "## Installing Jellyfin" | tee --append $LOG
apt -y update
apt -y upgrade
curl https://repo.jellyfin.org/install-debuntu.sh | bash

echo "## Copy across configuration"
tar -xvf jellyfin_config.tar.gz
mv jellyfin/ /etc/

apt -y autoremove

reboot
