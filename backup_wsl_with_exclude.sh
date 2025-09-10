#!/bin/bash
set -e

# Ensure the script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

user=$(echo $USER | tr '[:lower:]' '[:upper:]')
sudo tar \
    -czpvPf \
    /mnt/c/Users/$user/backup.tar.gz \
    --exclude=/proc \
    --exclude=/dev \
    --exclude=/mnt \
    --exclude=/media \
    --exclude=/lost+found \
    --exclude=/tmp \
    --exclude=/sys \
    --exclude=/run \
    --exclude=/home/$user/repos \
    /
