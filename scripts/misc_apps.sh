#!/bin/bash

# This file should be empty on the 'master' branch (used as template) and be filled in the git branches corresponding to specific environments.
# Misc applications

# Import helper functions
. $(dirname "$0")/_helper.sh

install_utility_apps() {
    # install has
    curl -sL https://git.io/_has > ~/bin/has
    chmod +x ~/bin/has
    # install tldr
    __install_binary $(__get_github_release_url "dbrgn/tealdeer" "x86_64-musl") tldr
    __install_global_zsh_completion 'https://raw.githubusercontent.com/dbrgn/tealdeer/master/zsh_tealdeer' _tldr
    # install tokei
    __install_tar_gz $(__get_github_release_url "XAMPPRocky/tokei" "x86_64.*linux-gnu.tar.gz") tokei
    # install bandwhich
    __install_tar_gz $(__get_github_release_url "imsnif/bandwhich" "linux-musl.tar.gz") bandwhich
    # install so
    __install_tar_gz $(__get_github_release_url "samtay/so" "linux-gnu.tar.gz") so
    # install zoxide (TODO: a voir si vraiment utile vs autojump)
    __install_binary $(__get_github_release_url "ajeetdsouza/zoxide" "x86_64.*linux-gnu") zoxide
    # install broot
    __install_binary 'https://dystroy.org/broot/download/x86_64-linux/broot' broot
    __install_global_zsh_completion 'https://dystroy.org/broot/download/completion/_br' _br
    __install_global_zsh_completion 'https://dystroy.org/broot/download/completion/_broot' _broot
    # install exa
    __install_zip $(__get_github_release_url "ogham/exa" "linux-x86_64.*.zip") exa-linux-x86_64 exa
    # install sd
    __install_binary $(__get_github_release_url "chmln/sd" "x86_64.*linux-gnu") sd
}
install_utility_apps

# FIXME: Source twice between oh-my-zsh plugins and directly by .zshrc
install zsh_plugins() {
    # install frogit
    __install_private_zsh_plugin 'https://github.com/wfxr/forgit/blob/master/forgit.plugin.zsh'
    # zsh-nvm
    __install_private_zsh_plugin 'https://github.com/lukechilds/zsh-nvm/blob/master/zsh-nvm.plugin.zsh'
    # install fzf-marks
    __install_private_zsh_plugin 'https://github.com/urbainvaes/fzf-marks/blob/master/fzf-marks.plugin.zsh'
    # zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/private/plugins/zsh-syntax-highlighting
}
install zsh_plugins