#!/bin/bash

# generate a gpg key and init pass store

export GPG_TTY=$(tty)
rm -rf ~/.gnupg ~/.password-store
gpgconf --kill gpg-agent
gpg-connect-agent reloadagent /bye
gpg-connect-agent updatestartuptty /bye

# Prompt the user for a password, hiding the input
read -s -p "Enter passphrase for your new gpg key: " passphrase
echo "You entered: $passphrase"
read -p "Enter Full Name: " fullname
echo "You entered: $fullname"
read -p "Enter Email: " email
echo "You entered: $email"
read -p "Enter Comment: " comment
echo "You entered: $comment"

# gen key
gpg --batch --passphrase $passphrase --quick-generate-key "$fullname ($comment) <$email>" ed25519 cert never

cat >~/.gnupg/gpg-agent.conf <<EOF
pinentry-program $(which pinentry)
enable-ssh-support
# Don't ask gnome-keyring for password
no-allow-external-cache
EOF

# gen sub key
for i in $(gpg --list-secret-keys --with-colons --fingerprint | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p'); do
    KEYFP=$i
    echo create subkey - sign
    sleep 2
    gpg --batch --passphrase $passphrase --quick-add-key $KEYFP ed25519 sign 1y
    echo create subkey - encr
    sleep 2
    gpg --batch --passphrase $passphrase --quick-add-key $KEYFP cv25519 encr 1y
    echo create subkey - auth
    sleep 2
    gpg --batch --passphrase $passphrase --quick-add-key $KEYFP ed25519 auth 1y
done

echo show key
gpg -K

# init pass store using new key
pass init $(gpg --list-secret-keys --with-colons --fingerprint | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p')

exit
# delete all keys
for i in $(gpg --list-secret-keys --with-colons --fingerprint | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p'); do
    gpg --batch --delete-secret-keys $i
done
