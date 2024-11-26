#!/usr/bin/env bash

# Create an archive that includes the contents of the /etc directory and the /home directory.
tar -czf /var/tmp/backup.tgz /etc /home

# Copy the archive to a remote server (provided as an argument to the script) using the scp command. If the argument is not provided, do nothing.
if [ -z $1 ]; then
    echo "No remote server provided."
    echo "Backup saved to /var/tmp/backup.tgz."
    exit
fi
echo "Copying backup to $1..."
scp /var/tmp/backup.tgz $1:/var/tmp

# Remove the archive from the local server unless the -k option is provided.
if [ "$2" == "-k" ]; then
    echo "Backup saved to /var/tmp/backup.tgz."
    exit
fi
rm /var/tmp/backup.tgz
