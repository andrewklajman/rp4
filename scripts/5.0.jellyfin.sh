echo "# 4.audiobookshelf.sh"
echo " - DISPLAY: $DISPLAY"

echo "## Notes
  - http://192.168.0.214:8096/web/
  - Credentials: jellyfin, jellyfin
"

echo "## Creating folders" | tee --append $LOG
mkdir /mnt/jellyfin
mkdir /mnt/jellyfin/movies
mkdir /mnt/jellyfin/torrent
chmod -R 775 /mnt/jellyfin
chown -R root:mnt_access /mnt/jellyfin

echo "## Installing Jellyfin" | tee --append $LOG
curl https://repo.jellyfin.org/install-debuntu.sh | bash

echo "## Only allow docker to run after mnt.service has run"
sed 's/\[Unit\]/[Unit]\nAfter=mnt.mount\nRequires=mnt.mount/' /usr/lib/systemd/system/jellyfin.service > jellyfin.service.modified
mv jellyfin.service.modified /usr/lib/systemd/system/jellyfin.service

#echo "## Copy across configuration"
#tar -xvf ../files/jellyfin_config.tar.gz
#rm -r /etc/jellyfin
#mv jellyfin/ /etc/

