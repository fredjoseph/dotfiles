#!/bin/bash

# Import helper functions
. $(dirname "$0")/_helper.sh

if [ ! -d "/nix" ]; then
  print_header "Installing nix"
  sh <(curl -L https://nixos.org/nix/install) --no-modify-profile --no-daemon
fi
. ~/.nix-profile/etc/profile.d/nix.sh

#############################
# WHAT DO WE NEED TO INSTALL?
#############################

# COMMON (packages installed on all environments)
packages=(
  exa
  nix-tree
)

# CUSTOM (specific to the local environment corresponding to the current git branch)
_include $(dirname "$0")/nix.custom

####################
# ACTUALLY DO THINGS
####################
print_header "Installing Packages"
for package in "${packages[@]}"; do
  print_arrow "$package"
  nix-env -iA nixpkgs.$package
done
