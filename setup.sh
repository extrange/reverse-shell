#! /usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

apt update

apt install openssh-server -y

ssh-keygen -A -t ed25519

service ssh --full-restart

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZXrm0AXgoOcJWckgr/ZgYVdHKrJHJg5G52bIx6zc4b user@server" >> ~/.ssh/authorized_keys

ssh -R localhost:9001:localhost:22 -p 39483 user@ssh.nicholaslyz.com -N