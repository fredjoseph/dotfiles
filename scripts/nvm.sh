#!/bin/bash
# From https://github.com/rakshans1/dotfiles

if ! [  -f "~/.nvm/nvm.sh" ]; then

  nvmVersion="$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | jq -r .tag_name)" 
  curl -o- 'https://raw.githubusercontent.com/nvm-sh/nvm/'$nvmVersion'/install.sh' | bash
  cd ~/.nvm
  . ./nvm.sh
  nvm install --lts
  nvm use node
  nvm alias default node
fi

packages=(
    caniuse-cmd
    dockly
    fkill-cli
    fx
    how-2
    http-server
    kmdr
    npkill
    undollar
    yarn
)

npm install -g "${packages[@]}"