echo "# 6.metube.sh"
echo " - DISPLAY: $DISPLAY"

echo "## Notes:
  - Browser extension: Right mouse click video to sent to MeTube
  - https://github.com/containrrr/watchtower: recommended to overcome updated container images
  - Deatils about SSL generation
  			https://stackoverflow.com/questions/10175812/how-to-generate-a-self-signed-ssl-certificate-using-openssl#10176685

  "

echo "## Creating folders"
mkdir /mnt/metube
mkdir /mnt/metube/downloads
mkdir /mnt/metube/ssl

echo "## Creating SSL certificates"
openssl req -nodes -x509 -newkey rsa:4096 \
	-keyout /mnt/metube/ssl/key.pem \
	-out /mnt/metube/ssl/cert.pem \
	-sha256 -days 3650 -nodes \
	-subj "/C=XX/ST=StateName/L=CityName/O=CompanyName/OU=CompanySectionName/CN=CommonNameOrHostname"

echo "## Creating container"
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
      - /mnt/metube/ssl:/ssl
    environment:
      - HTTPS=true
      - CERTFILE=/ssl/cert.pem
      - KEYFILE=/ssl/key.pem
" > /mnt/metube/docker-compose.yml

echo "## Creating link to Jellyfin" 
if [ -d "/mnt/jellyfin" ]; then
	ln -s /mnt/metube/downloads /mnt/jellyfin/metube
fi
chmod -R 775 /mnt
chown -R root:mnt_access /mnt

echo "## Running container"
cd /mnt/metube
systemctl restart docker.service
docker-compose up -d

apt -y autoremove

reboot
