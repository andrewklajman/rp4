COMMENT="$1"

DOWNLOAD_URL_1MB="https://onlinetestcase.com/wp-content/uploads/2023/06/1.1-MB.bmp"
DOWNLOAD_URL_15MB="https://onlinetestcase.com/wp-content/uploads/2023/06/15.8-MB.bmp"

DOWNLOAD_URL=$DOWNLOAD_URL_1MB

LOG="$(date +%F_%H%M.log)"
DST="$(pwd)"

cd /tmp
{ time wget $DOWNLOAD_URL -olog; } 2> TIME_OUTPUT
SIZE=$(grep Length log | cut -d'(' -f2 | cut -d')' -f1)
SPEED=$(grep real TIME_OUTPUT | awk '{ print $2 }')
RECORD="$(cat /etc/hostname)|$(date)|$SIZE|$SPEED|$COMMENT"

echo $RECORD
echo $RECORD >> "$DST/log.txt"
