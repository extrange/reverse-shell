#! /usr/bin/env bash

set -euox pipefail

JUMP_HOST_HOSTNAME="ec2-18-143-74-176.ap-southeast-1.compute.amazonaws.com"
JUMP_HOST_USERNAME="nicholas"
JUMP_HOST_PORT=9999

# Keys which will be allowed to connect to the sagemaker host, via the jump host
AUTHORIZED_KEYS="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEZXrm0AXgoOcJWckgr/ZgYVdHKrJHJg5G52bIx6zc4b server@nicholas
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3RCwHWzK/gKI8Lplk/qoaoJemh8h/op5Oe7/IXepWK laptop@nicholas
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGyJ0LttXH9j3Ql7J1ccJbhLWdYhYn24qR6a8ur72hVi desktop@nicholas"

# Added to the sagemaker host's known_hosts
JUMP_HOST_KEY="$JUMP_HOST_HOSTNAME ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKG408vS6+iix/ZVHASXcSsILGlsqq5jSIf+s2ORHLzI"

sudo apt update && sudo apt install openssh-server vim bash-completion apt-transport-https ca-certificates curl gnupg -y

sudo ssh-keygen -A && sudo service ssh --full-restart

mkdir -p ~/.ssh
touch "$HOME/.ssh/authorized_keys"
touch "$HOME/.ssh/known_hosts"
echo "$AUTHORIZED_KEYS" >>"$HOME/.ssh/authorized_keys"
echo "$JUMP_HOST_KEY" >>"$HOME/.ssh/known_hosts"
chmod 0600 -R "$HOME/.ssh/authorized_keys"

{ yes || :; } | sudo unminimize

# Kubectl
if ! command -v kubectl; then
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor --batch --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg # allow unprivileged APT programs to read this keyring
    echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list # helps tools such as command-not-found to work correctly
    sudo apt update && sudo apt install -y kubectl
    echo 'source /etc/bash_completion' >>~/.bashrc
    echo 'source <(kubectl completion bash)' >>~/.bashrc
fi

# Kompose
if ! command -v kompose; then
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.34.0/kompose-linux-amd64 -o kompose
    chmod +x kompose
    mkdir -p ~/.local/bin
    mv ./kompose ~/.local/bin/kompose
fi

# Starship
if ! command -v starship; then
    sh -c " $(curl -sS https://starship.rs/install.sh)" -y -f
    # shellcheck disable=SC2016
    echo 'eval "$(starship init bash)' >>~/.bashrc
fi

# Open a reverse shell on the jump host, listening on the specified port
ssh -R ":$JUMP_HOST_PORT:localhost:22" "$JUMP_HOST_USERNAME@$JUMP_HOST_HOSTNAME" -N
