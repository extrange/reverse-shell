#! /usr/bin/env bash

SERVER_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZXrm0AXgoOcJWckgr/ZgYVdHKrJHJg5G52bIx6zc4b user@ssh.nicholaslyz.com:39483"

sudo apt update

sudo apt install openssh-server -y

sudo ssh-keygen -A

sudo service ssh --full-restart

touch "$HOME/.ssh/authorized_keys"
touch "$HOME/.ssh/known_hosts"
echo "$SERVER_KEY" >> "$HOME/.ssh/authorized_keys"
echo "$SERVER_KEY" >> "$HOME/.ssh/known_hosts"
chown -R "$USER" "$HOME/.ssh"
chmod 0600 -R "$HOME/.ssh"

ssh -R localhost:9001:localhost:22 -p 39483 user@ssh.nicholaslyz.com -N