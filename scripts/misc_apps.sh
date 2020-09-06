#!/bin/bash

print_info() {
  # Print output in purple
  printf "\n\e[0;35m $1\e[0m\n\n"
}

install_zsh() {
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d ~/.oh-my-zsh ]]; then
      cd ~ && git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      chsh -s $(which zsh)
    fi
  else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
      if [[ -f /etc/redhat-release ]]; then
        sudo yum install zsh
        install_zsh
      fi
      if [[ -f /etc/debian_version ]]; then
        sudo apt-get -qq install zsh
        install_zsh
      fi
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
      echo "We'll install zsh, then re-run this script!"
      brew install zsh
      exit
    fi
  fi
}
install_zsh
chsh -s /bin/zsh $whoami

install_fzf() {
    if [ ! -d ~/.fzf ]; then
      print_info "Installing fzf"
      git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
      ~/.fzf/install
    fi
}
install_fzf

install_utility_apps() {
    # install has
    curl -sL https://git.io/_has > ~/bin/has
    chmod +x ~/bin/has
}
install_utility_apps