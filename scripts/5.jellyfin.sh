# Notes
#   - http://192.168.0.214:8096/web/
#   - Credentials: jellyfin, jellyfin

LOG=$(date +/root/log/%F_installation.log)

echo "--- Jellyfin ---" | tee --append $LOG

echo "  - Creating folders" | tee --append $LOG
mkdir /mnt/jellyfin
mkdir /mnt/jellyfin/movies
chmod -R 775 /mnt
chown -R root:mnt_access /mnt

echo "  - Installing Jellyfin" | tee --append $LOG
apt -y update
apt -y upgrade
curl https://repo.jellyfin.org/install-debuntu.sh | bash

echo "# Copy across configuration"
tar -xvf jellyfin_config.tar.gz
mv jellyfin/ /etc/

reboot
