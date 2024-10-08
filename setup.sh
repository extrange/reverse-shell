#! /usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

USER=sagemaker-user
SERVER_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZXrm0AXgoOcJWckgr/ZgYVdHKrJHJg5G52bIx6zc4b user@server"
USER_DIR="/home/$USER"

apt update

apt install openssh-server -y

ssh-keygen -A -t ed25519

service ssh --full-restart

touch "$USER_DIR/.ssh/authorized_keys"
touch "$USER_DIR/.ssh/known_hosts"
echo "$SERVER_KEY" >> "$USER_DIR/.ssh/authorized_keys"
echo "$SERVER_KEY" >> "$USER_DIR/.ssh/known_hosts"
chown -R "$USER" "$USER_DIR/.ssh"
chmod 0600 -R "USER_DIR/.ssh"

ssh -R localhost:9001:localhost:22 -p 39483 user@ssh.nicholaslyz.com -N