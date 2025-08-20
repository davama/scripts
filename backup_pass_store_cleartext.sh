#!/usr/bin/env bash
# export passwords to external file

shopt -s nullglob globstar
prefix=${PASSWORD_STORE_DIR:-$HOME/.password-store}

target_file="/tmp/passwords_from_pass"
cat /dev/null > $target_file
echo "Exporting passwords to $target_file"

for file in "$prefix"/**/*.gpg; do
    file="${file/$prefix//}"
    printf "%s\n" "Name: ${file%.*}" >> "$target_file"
    pass "${file%.*}" >> "$target_file"
    printf "\n\n" >> "$target_file"
done
