#!/bin/bash

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

install_dotfiles() {
    # Remove already present configuration files to avoid 'stow' conflict
    rm -f ~/.bashrc
    rm -f ~/.zshrc
    rm -f ~/.gitconfig
    
    stow -R bash git postgres ripgrep stow tmux vi zsh misc
}

install_all() {
# Ask for the administrator password upfront
sudo -v
# Global Linux
$HOME/dotfiles/scripts/linux.sh
# Cool apps
$HOME/dotfiles/scripts/common_apps.sh
$HOME/dotfiles/scripts/misc_apps.sh
# Snap
$HOME/dotfiles/scripts/snap.sh
# Nvm
$HOME/dotfiles/scripts/nvm.sh
# Docker
$HOME/dotfiles/scripts/docker.sh
# Symlinks
install_dotfiles
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