bash 2.setup.sh | tee --append $(date +../log/%F.log)
bash 3.qbittorrent.sh | tee --append $(date +../log/%F.log)
bash 4.audiobookshelf.sh | tee --append $(date +../log/%F.log)
bash 5.jellyfin.sh | tee --append $(date +../log/%F.log)
bash 6.metube.sh | tee --append $(date +../log/%F.log)
bash 7.proxyserver.sh | tee --append $(date +../log/%F.log)


