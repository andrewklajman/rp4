#bash 2.0.setup.sh | tee --append $(date +../log/%F.log)
echo "Have you run scripts 2 and 2.1?"
read
bash 3.0.qbittorrent.sh | tee --append $(date +../log/%F.log)
bash 4.0.audiobookshelf.sh | tee --append $(date +../log/%F.log)
bash 5.0.jellyfin.sh | tee --append $(date +../log/%F.log)
bash 6.0.metube.sh | tee --append $(date +../log/%F.log)
bash 7.0.proxyserver.sh | tee --append $(date +../log/%F.log)


