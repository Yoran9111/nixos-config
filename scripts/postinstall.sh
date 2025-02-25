#!/bin/sh

set -e

USER=jip
UHOME=/home/$USER

# Setup my configuration lib
sudo -u $USER mkdir -p $UHOME/lib
sudo -u $USER git clone https://github.com/Yoran9111/nixos.git $UHOME/lib/nixos
sudo -u $USER git -C $UHOME/lib/nixos remote set-url --push origin git@github.com:KibaFox/nixos.git

# Install nixos configuration
mv /etc/nixos/configuration.nix /etc/nixos/bak.nix
ln -s $UHOME/lib/nixos/machines/vbox.nix /etc/nixos/configuration.nix
nixos-rebuild switch --upgrade

# Cleanup any previous generations and delete old packages
nix-collect-garbage -d
