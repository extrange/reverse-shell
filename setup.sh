#! /usr/bin/env bash

set -euo pipefail

AUTHORIZED_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZXrm0AXgoOcJWckgr/ZgYVdHKrJHJg5G52bIx6zc4b user@ssh.nicholaslyz.com:39483"
SERVER_KEY="[ssh.nicholaslyz.com]:39483 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAm3fEcDvIM7cFCjB3vzBb4YctOGMpjf8X3IxRl5HhjV"

sudo apt update

sudo apt install openssh-server vim -y

sudo ssh-keygen -A

sudo service ssh --full-restart

mkdir -p ~/.ssh
touch "$HOME/.ssh/authorized_keys"
touch "$HOME/.ssh/known_hosts"
echo "$AUTHORIZED_KEY" >> "$HOME/.ssh/authorized_keys"
echo "$SERVER_KEY" >> "$HOME/.ssh/known_hosts"
chmod 0600 -R "$HOME/.ssh/authorized_keys"

yes | sudo unminimize

# Starship
curl -sS https://starship.rs/install.sh | sh
echo 'eval "$(starship init bash)' >> ~/.bashrc

# Kubectl
sudo apt install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list   # helps tools such as command-not-found to work correctly
sudo apt update && sudo apt install -y kubectl


ssh -R localhost:9001:localhost:22 -p 39483 user@ssh.nicholaslyz.com -N