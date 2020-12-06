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