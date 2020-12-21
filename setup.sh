#!/bin/bash

# Import helper functions
. $(dirname "$0")/scripts/_helper.sh

# Print usage message.
usage() {
  local program_name
  program_name=${0##*/}
  echo "\
Usage: $program_name [-option]
Options:
  -h|--help       Print this message
  -d|--dotfiles   Install dotfiles
  -a|--all        Install all (softwares && dotfiles)
"
}

ask_for_sudo() {
  # Ask for the administrator password upfront
  sudo -v

  # Update existing `sudo` time stamp until this script has finished
  # https://gist.github.com/cowboy/3118588
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done &> /dev/null &
}

install_dotfiles() {
  # Remove already present configuration files to avoid 'stow' conflict
  rm -f ~/.bashrc
  rm -f ~/.zshrc
  rm -f ~/.gitconfig
  
  stow -R bash git kde misc nvm postgres ripgrep stow tmux vi zsh
  print_header "Apply App Settings"
  $(dirname "$0")/scripts/settings.sh
}

cleanup() {
  rm -f ~/.zcompdump*
}

install_all() {
  # Ask for the administrator password upfront
  ask_for_sudo
  # Global Linux
  $(dirname "$0")/scripts/linux.sh
  # Cool apps
  $(dirname "$0")/scripts/common_apps.sh
  $(dirname "$0")/scripts/misc_apps.sh
  # Snap
  $(dirname "$0")/scripts/snap.sh
  # NVM
  $(dirname "$0")/scripts/nvm.sh
  # Docker
  $(dirname "$0")/scripts/docker.sh
  # Symlinks
  print_header "Symlink configuration files"
  install_dotfiles
  print_header "Cleanup"
  cleanup
}

main() {
  case "$1" in
    ''|-h|--help)
      usage
      exit 0
      ;;
    -d|--dotfiles)
      install_dotfiles
      ;;
    -a|--all)
      install_all
      ;;
    *)
      echo "Command not found" >&2
      exit 1
  esac
}

main "$@"