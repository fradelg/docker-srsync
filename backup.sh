#!/bin/bash
KEYFILE=/root/.ssh/id_rsa
BACKUP_DATE=`date +%Y.%m.%d-%H:%M`
OPTS="-az --exclude-from=/exclude.txt"

echo "=> Backup started at $BACKUP_DATE"
rsync $OPTS -e "ssh -i $KEYFILE -p $HOST_PORT" /backup/ $HOST_USER@$HOST_NAME:$HOST_DIR
echo "=> Backup done"
