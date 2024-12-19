DEVICE=$1
COMMENT=$2
# Note this will probably not work on encrypted devices
#
READ_SPEED=$(hdparm -t $DEVICE | \
	tail -n1 | \
	cut -d'=' -f2 | \
	sed 's/^[ \t]*//;s/[ \t]*$//')

MOUNT_POINT=$(mount | grep $DEVICE | awk '{ print $3 }')
sync
dd if=/dev/zero of=$MOUNT_POINT"/tempfile" bs=1M count=1024 > /tmp/dd_output 2>&1
sync
rm $MOUNT_POINT"/tempfile"
WRITE_SPEED=$(cat /tmp/dd_output | tail -n1 | cut -d',' -f4 | sed 's/^[ \t]*//;s/[ \t]*$//')

RECORD="$(cat /etc/hostname)|$DEVICE|$(date)|$READ_SPEED|$WRITE_SPEED|$COMMENT"
echo $RECORD
echo $RECORD >> diskperformance.log
