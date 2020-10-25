#!/bin/bash
# From https://github.com/rakshans1/dotfiles

# Import helper functions
. $(dirname "$0")/_helper.sh

if ! [  -f "~/.nvm/nvm.sh" ]; then
  nvmVersion="$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .tag_name)" 
  curl -o- 'https://raw.githubusercontent.com/nvm-sh/nvm/'$nvmVersion'/install.sh' | bash
  cd ~/.nvm
  . ./nvm.sh
  nvm install --lts
  nvm use node
  nvm alias default node
fi

#############################
# WHAT DO WE NEED TO INSTALL?
#############################

# COMMON (packages installed on all environments)
packages=(
    fkill-cli
    how-2
    http-server
    kmdr
    npkill
    undollar
)

# CUSTOM (specific to the local environment corresponding to the current git branch)
_include $(dirname "$0")/nvm.custom

####################
# ACTUALLY DO THINGS
####################
npm install -g "${packages[@]}"

# Save the list of packages as default packages (will be installed every time a new version of Node is installed)
printf '%s\n' "${packages[@]}" > ~/.nvm/default-packages