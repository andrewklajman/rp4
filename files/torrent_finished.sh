CATEGORY=$1
CONTENT_PATH=$2
LOG="/mnt/qbittorrent-nox/scripts/log"

echo "-----$(date)--------" >> $LOG
echo "CATEGORY: $CATEGORY" >> $LOG
echo "CONTENT_PATH: $CONTENT_PATH" >> $LOG
if [ "$CATEGORY" == "audiobookshelf" ]; then
        ln -s $CONTENT_PATH /mnt/audiobookshelf/audiobooks | tee --append $LOG
fi
echo "" >> $LOG
