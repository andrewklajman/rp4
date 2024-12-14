SCRIPT=$1

bash $SCRIPT | tee --append $(date +../log/%F.log)
