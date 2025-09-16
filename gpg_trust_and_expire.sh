#!/bin/bash

# get first key
key=$(gpg --list-secret-keys --with-colons --fingerprint | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' | head -1 | tail -c 9)

KEY_ID=$key

expect <<EOF
  set key_id "$KEY_ID"

  spawn gpg --edit-key \$key_id

  # Trust the key
  expect "gpg>"
  send "trust\r"

  expect "Your decision?"
  send "5\r"

  expect "Do you really want to set this key to ultimate trust?"
  send "y\r"

  # Set expiration for primary key
  expect "gpg>"
  send "expire\r"

  expect "Please specify how long the key should be valid."
  send "1y\r"

  expect "Is this correct?"
  send "y\r"

  # Loop through subkeys dynamically
  set subkey_index 1
  while {1} {
    expect {
      "gpg>" {
        send "key \$subkey_index\r"
        expect {
          "No subkey with index" {
            send "key 0\r"
            break
          }
          "gpg>" {
            send "expire\r"
            expect {
                "Please specify how long the key should be valid." {send "1y\r"; exp_continue}
                "Are you sure you want to change the expiration time for multiple subkeys? (y/N)" {send "y\r"; exp_continue}
                "Is this correct?" {send "y\r"; exp_continue}
                "gpg>" {send "\r"}
            }
            incr subkey_index
          }
        }
      }
    }
  }

  # Save and quit
  expect "gpg>"
  send "save\r"

  expect eof
EOF
