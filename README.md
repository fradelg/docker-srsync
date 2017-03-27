# Secure RSYNC: backup a volume using rsync over sftp

## Features

  - You only have to provide your password once, in the first execution
  - RSA public-private keypair is created for secure connection to server
  - Your password will be wiped out once the container was authorized by the backup server
  - Backup any docker volume or host-mounted directory

## How to use it?

The following docker command creates a container to backup your volume into sftp://backup@mybackupserver.mydomain.com:/backup

```
docker run -e "BACKUP_NOW=yes" \
           -e "HOST_USER=backup" \
           -e "HOST_NAME=mybackupserver.mydomain.com" \
           -e "HOST_DIR=/backup"
           -v volume_to_backup:/backup
           -v password_file:/ssh.pass
           --name sftp-backup
           fradelg/sftp-backup
```

### Mount points

  - `/ssh.pass`: the file with your server pass stored as plain text. It will be erased after creating the container
  - `/backup`: the directory that contains the files to backup into the remote server
  - `/root/.ssh`: the SSH keys of the user to connect with the backup remote host

### Environment variables

  - `BACKUP_NOW`: does the container perform a complete backup after creation? (it will take a while)
  - `HOST_USER`: the username of the backup account in the server
  - `HOST_NAME`: the hostname or IP of the backup server
  - `HOST_PORT`: the port where SFTP is listening on the backup server
  - `HOST_DIR`: the path of the backup to which the backup will be saved
  - `EXCLUDE`: the file patterns to exclude from rsync (single space separated)
  - `CRON_TIME`: the crontab time pattern for executing the backup (default: 0 0 * * 7)
