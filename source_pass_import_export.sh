#!/bin/bash
# Source: https://www.passwordstore.org/
# GPG export and import functions for password-store
# Usage:
# gpg_export_password-store
# gpg_import_password-store <file>
# Example:
# gpg_export_password-store
# gpg_import_password-store password-store-backup.tar.gz.gpg
# Note: This script assumes you have GPG and password-store installed and configured.

function gpg_export_password-store () {
	cd
        key=$(gpg --list-secret-keys --with-colons --fingerprint | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' | head -1 | tail -c 9)
	key_delta=$(echo $key | sed 's/^/0x/g')
	tar -cz .password-store | gpg --sign --encrypt -r $key_delta > password-store-backup.tar.gz.gpg
	ls password-store-backup.tar.gz.gpg
	unset key key_delta
}
function gpg_import_password-store () {
	if [ -z $1 ]; then
		echo "Need password store tar file"
	else
		file=$1
		gpg --decrypt < $file | tar -xz
		unset file
	fi
}
