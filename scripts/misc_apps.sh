#!/bin/bash

# This file is used as a template file on the 'master' branch and should be filled if required in the git branches corresponding to specific environments.
# Misc applications

# Import helper functions
. $(dirname "$0")/_helper.sh

print_header "Installing specific environment Apps"

install_utility_apps() {
  mkdir -p ~/bin
  print_arrow "has"
  curl -sL https://git.io/_has > ~/bin/has && chmod +x ~/bin/has
  print_arrow "tldr"
  __install_binary $(__get_github_release_url "dbrgn/tealdeer" "x86_64-musl") tldr
  __install_global_zsh_completion 'https://raw.githubusercontent.com/dbrgn/tealdeer/master/zsh_tealdeer' _tldr
  print_arrow "tokei"
  __install_tar_gz $(__get_github_release_url "XAMPPRocky/tokei" "x86_64.*linux-gnu.tar.gz") tokei
  print_arrow "bandwhich"
  __install_tar_gz $(__get_github_release_url "imsnif/bandwhich" "linux-musl.tar.gz") bandwhich
  print_arrow "so"
  __install_tar_gz $(__get_github_release_url "samtay/so" "linux-gnu.tar.gz") so
  print_arrow "zoxide"
  __install_binary $(__get_github_release_url "ajeetdsouza/zoxide" "x86_64.*linux-gnu") zoxide
  print_arrow "broot"
  __install_binary 'https://dystroy.org/broot/download/x86_64-linux/broot' broot
  __install_global_zsh_completion 'https://dystroy.org/broot/download/completion/_br' _br
  __install_global_zsh_completion 'https://dystroy.org/broot/download/completion/_broot' _broot
  print_arrow "exa"
  __install_zip $(__get_github_release_url "ogham/exa" "linux-x86_64.*.zip") exa-linux-x86_64 exa
  print_arrow "sd"
  __install_binary $(__get_github_release_url "chmln/sd" "x86_64.*linux-gnu") sd
  print_arrow "tmpmail"
  curl -sL "https://git.io/tmpmail" > ~/bin/tmpmail && chmod +x ~/bin/tmpmail
  print_arrow "gitui"
  __install_tar_gz $(__get_github_release_url "extrawurst/gitui" "linux-musl.tar.gz") gitui
}
install_utility_apps

print_header "Installing zsh plugins"

install_zsh_plugins() {
  print_arrow "fzf-marks"
  __get_local_zsh_plugin 'https://raw.githubusercontent.com/urbainvaes/fzf-marks/master/fzf-marks.plugin.zsh'
  print_arrow "zsh-nvm"
  __get_local_zsh_plugin 'https://raw.githubusercontent.com/lukechilds/zsh-nvm/master/zsh-nvm.plugin.zsh'
  local completion_date=$(curl -s "https://api.github.com/repos/zsh-users/zsh-completions/commits?path=src/_nvm&page=1&per_page=1" | jq -r '.[0].commit.committer.date')
  local my_completion=$(git log -1 --date=short --format="%ad" -- ../nvm/.zsh-custom/completions/_nvm)
  # FIXME: to be tested and switch
  if [[ $my_completion > $completion_date ]]; then print_warning "The completion file for '_nvm' seems outdated"; fi
  print_arrow "zsh-defer"
  __clone_local_zsh_plugin 'https://github.com/romkatv/zsh-defer.git'
  print_arrow "fast-syntax-highlighting"
  __clone_local_zsh_plugin 'https://github.com/zdharma/fast-syntax-highlighting.git'
}
install_zsh_plugins
