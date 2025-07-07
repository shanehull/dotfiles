#!/bin/bash

set -e

## Install nix ##
if ! type /nix/var/nix/profiles/default/bin/nix &> /dev/null; then
  curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
fi

## Build the flake ##
if [ ! -d ./nix/result ]; then
  /nix/var/nix/profiles/default/bin/nix build -o ./nix/result ./nix/.#darwinConfigurations.${1}.system --extra-experimental-features 'nix-command flakes'
fi

## Install the flake system wide ##
./nix/result/sw/bin/darwin-rebuild switch --flake "./nix/#${1}"

## Source nix packages for this shell ##
export PATH=$PATH:/etc/profiles/per-user/${USER}/bin/

## Install mise plugins and tools ##
cp ./mise-config-${1}.toml ./mise/config.toml
mise plugin install --all && mise install
