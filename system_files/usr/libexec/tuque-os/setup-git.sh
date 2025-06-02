#!/usr/bin/env bash

set -euo pipefail

if [ ! -f "${HOME}/.ssh/id_ed25519.pub" ]; then
    echo "Generating SSH key..."
    ssh-keygen -t ed25519
else
  echo "SSH already exists"
fi

echo "Your SSH public key:"
cat "${HOME}/.ssh/id_ed25519.pub"

echo "Setting up Git config..."
mkdir -p "${HOME}/.config/git"
touch "${HOME}/.config/git/config"

read -rp "Enter your Git username: " git_username
read -rp "Enter your Git email: " git_email

git config --global color.ui true
git config --global user.name "$git_username"
git config --global user.email "$git_email"

git config --global merge.ff only
git config --global pull.ff only
git config --global push.autoSetupRemote true
git config --global init.defaultbranch main
git config --global diff.external difft

echo "Setup GPG to use SSH key..."
git config --global gpg.format ssh;
git config --global user.signingkey "key::$(cat "${HOME}/.ssh/id_ed25519.pub")";
git config --global commit.gpgSign true
