#!/bin/bash

# create a backup of the wsl but excluding files/directories

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
