#!/bin/bash
# From https://github.com/rakshans1/dotfiles

# Import helper functions
. $(dirname "$0")/_helper.sh

packages=()

cpackages=()

#############################
# WHAT DO WE NEED TO INSTALL?
#############################

# COMMON (packages installed on all environments)
cpackages+=(
    code
)

# CUSTOM (specific to the local environment corresponding to the current git branch)
_include $(dirname "$0")/snap.custom

####################
# ACTUALLY DO THINGS
####################
sudo snap install "${packages[@]}"

for package in "${cpackages[@]}"
do
  :
  sudo snap install "${package}" --classic
done
