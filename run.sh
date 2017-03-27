#!/bin/bash
KEYFILE=/root/.ssh/id_rsa
PASSFILE=/ssh.pass
EXCLUDEFILE=exclude.txt
CRONTAB=/crontab.conf

if [ ! -f $KEYFILE ]
then
  if [ -s $PASSFILE ]
  then
    echo "=> Registering the container in $HOST_NAME with password file provided ..."
    ssh-keygen -q -t rsa -N "" -f $KEYFILE
    sshpass -f $PASSFILE ssh-copy-id -i $KEYFILE.pub -o StrictHostKeyChecking=no $HOST_USER@$HOST_NAME
    echo "=> Your password has been erased for security"
    > $PASSFILE
  else
    echo "[ERROR] You must provide a password to connect to remote server"
    echo "Mount a file with your clear password in /ssh.pass. It will be removed after"
    echo "Alternatively, you can mount your .ssh dir with your SSH keys into /root/.ssh"
    exit
  fi
fi

if [ ! -f $EXCLUDEFILE ]
then
  echo "=> Creating a file with the exclude patterns $EXCLUDEFILE"
  echo $EXCLUDE | tr " " "\n" > $EXCLUDEFILE
fi

if [ ! -f $CRONTAB ]
then
  echo "=> Creating crontab in $CRONTAB ..."
  echo "$CRON_TIME /backup.sh >> /backup.log 2>&1" > $CRONTAB
  crontab $CRONTAB
fi

if [ ! -z $BACKUP_NOW ]
then
  echo "=> Performing an initial backup as requested. This could take a while ..."
  /backup.sh
fi

echo "=> Running cron forever"
exec crond -f
