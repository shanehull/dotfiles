#!/bin/bash

## Install nix ##
if ! type nix &> /dev/null; then
  curl -L https://nixos.org/nix/install | sh -s -- --daemon --yes
fi

## Install brew ##
# Some pkgs aren't available in nixpkgs, but we can manage brew from home-manager
if ! type brew &> /dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

## Build the flake ##
if [ ! -d ./nix/result ]; then
  nix build -o ./nix/result ./nix/.#darwinConfigurations.shed.system --extra-experimental-features 'nix-command flakes'
fi

## Install the flake system wide ##
./nix/result/sw/bin/darwin-rebuild switch --flake "./nix/#shed"

## Source nix packages for this shell ##
export PATH=$PATH:/etc/profiles/per-user/shane/bin/

## Install asdf plugins and tools ##
ASDF_DIR=$(dirname $(dirname $(readlink -f $(which asdf))))
. ${ASDF_DIR}/asdf.sh
# Install asdf tool plugins
cut -d' ' -f1 .tool-versions|xargs -I{} asdf plugin add {}
# Install asdf tools (./.tool-versions is used and also cp'd to $HOME)
asdf install
# Set global versions to the versions specific in .tool-versions
cat .tool-versions | while read line ; do
    eval asdf global $line
done
