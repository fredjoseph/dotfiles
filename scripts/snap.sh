#!/bin/bash
# From https://github.com/rakshans1/dotfiles

# Import helper functions
. $(dirname "$0")/_helper.sh

#############################
# WHAT DO WE NEED TO INSTALL?
#############################

# COMMON (packages installed on all environments)
packages=()

cpackages=()

# CUSTOM (specific to the local environment corresponding to the current git branch)
_include $(dirname "$0")/snap.custom

####################
# ACTUALLY DO THINGS
####################
print_header "Installing SNAP packages (${#packages[@]})"
for package in "${packages[@]}"
do
  print_arrow "$package"
  sudo snap install "${package}"
done

print_header "Installing SNAP packages in classic mode (${#cpackages[@]})"
for package in "${cpackages[@]}"
do
  print_arrow "$package"
  sudo snap install "${package}" --classic
done
