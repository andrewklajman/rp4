# Create folders
    mkdir /mnt/audiobookshelf
    mkdir /mnt/audiobookshelf/audiobooks
    mkdir /mnt/audiobookshelf/podcasts
    mkdir /mnt/audiobookshelf/metadata
    mkdir /mnt/audiobookshelf/config

# Load configuration settings
    tar -xvf ./files/audiobookshelf_config.tar
	mv ./config /mnt/audiobookshelf/

# Create AudioBookShelf container
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
	chmod -R root:mnt_access /mnt
	chown -R 774 /mnt

# Run AudioBookShelf
    cd /mnt/audiobookshelf
    docker-compose up -d
