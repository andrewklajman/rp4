echo "# 4.audiobookshelf.sh"
echo " - DISPLAY: $DISPLAY"

echo "## Create folders"
mkdir /mnt/audiobookshelf
mkdir /mnt/audiobookshelf/audiobooks
mkdir /mnt/audiobookshelf/podcasts
mkdir /mnt/audiobookshelf/metadata
mkdir /mnt/audiobookshelf/config

echo "## Load configuration settings"
tar -xvf ../files/audiobookshelf_config.tar.gz
mv ./config /mnt/audiobookshelf/

echo "## Create AudioBookShelf container"
echo "
services:
  audiobookshelf:
    image: ghcr.io/advplyr/audiobookshelf:latest
    ports:
      - 13378:80
    volumes:
      - /mnt/audiobookshelf/audiobooks:/audiobooks
      - /mnt/audiobookshelf/podcasts:/podcasts
      - /mnt/audiobookshelf/metadata:/metadata
      - /mnt/audiobookshelf/config:/config
    restart: unless-stopped
" > /mnt/audiobookshelf/docker-compose.yml
chmod -R 775 /mnt
chown -R root:mnt_access /mnt

echo "## Run AudioBookShelf"
cd /mnt/audiobookshelf
systemctl restart docker.service
docker-compose up -d
