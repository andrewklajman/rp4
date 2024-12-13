LOG=$(date +/root/log/%F_installation.log)
echo "--- MeTube ---" | tee --append $LOG
echo "Notes:
  - Browser extension: Right mouse click video to sent to MeTube
  - https://github.com/containrrr/watchtower: recommended to overcome updated container images " | tee --append $LOG

echo "Installation:" | tee --append $LOG
echo " - Creating folders" | tee --append $LOG
mkdir /mnt/metube
mkdir /mnt/metube/downloads

echo " - Creating container"  |tee --append $LOG
echo "
services:
  metube:
    image: ghcr.io/alexta69/metube
    container_name: metube
    restart: always
    ports:
      - "8081:8081"
    volumes:
      - /mnt/metube/downloads:/downloads
      - /mnt/metube/ssl:/mnt/ssl
    environment:
      - HTTPS=true
      - CERTFILE=/ssl/cert.csr
      - KEYFILE=/ssl/ssl.key
" > /mnt/metube/docker-compose.yml

echo " - Creating link to Jellyfin"  | tee --append $LOG
if [ -d "/mnt/jellyfin" ]; then
	ln -s /mnt/metube/downloads /mnt/jellyfin/metube
fi
chmod -R 775 /mnt
chown -R root:mnt_access /mnt

echo " - Running container"  |tee --append $LOG
    cd /mnt/metube
    docker-compose up -d | tee --append $LOG

echo "" | tee --append $LOG

reboot
