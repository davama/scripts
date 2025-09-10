#!/usr/bin/env bash
# description: Backup all passwords from pass (the unix password manager) to a cleartext file
# usage: backup_pass_store_cleartext.sh
# note: make sure to delete the exported file after use, as it contains all passwords in cleartext
# note: requires 'pass' to be installed and configured
# note: requires gpg to be set up with the appropriate keys
# note: the exported file is saved to /tmp/passwords_from_pass
# note: ensure that /tmp is secure and cleaned up regularly

shopt -s nullglob globstar
prefix=${PASSWORD_STORE_DIR:-$HOME/.password-store}

target_file="/tmp/passwords_from_pass"
cat /dev/null > $target_file
chmod 600 target_file
echo "Exporting passwords to $target_file"

for file in "$prefix"/**/*.gpg; do
    file="${file/$prefix//}"
    printf "%s\n" "Name: ${file%.*}" >> "$target_file"
    pass "${file%.*}" >> "$target_file"
    printf "\n\n" >> "$target_file"
done
