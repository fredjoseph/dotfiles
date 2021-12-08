#!/bin/bash

# Common applications shared by all environments

# Import helper functions
. $(dirname "$0")/_helper.sh

print_header "Installing Common Apps"

install_zsh() {
  # Test to see if zshell is installed.  If it is:
  if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Install Oh My Zsh if it isn't already present
    if [[ ! -d ~/.oh-my-zsh ]]; then
      cd ~ && git clone https://github.com/robbyrussell/oh-my-zsh.git .oh-my-zsh
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
      print_info "Change default shell to zsh"
      chsh -s $(which zsh)
    fi
  else
    print_arrow "zsh"
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

install_common_zsh_plugins() {
  print_arrow "zsh-defer"
  __clone_local_zsh_plugin 'https://github.com/romkatv/zsh-defer.git'
}
install_common_zsh_plugins

install_fzf() {
  if [ ! -d ~/.fzf ]; then
    print_arrow "fzf"
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
  fi
}
install_fzf

install_tmux_plugin_manager() {
  if [ ! -d ~/.tmux/plugins/tpm ]; then
      print_arrow "TPM (tmux plugin manager)"
      git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  fi
}
install_tmux_plugin_manager
