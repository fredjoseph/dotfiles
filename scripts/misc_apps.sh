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
  print_arrow "tmpmail"
  curl -sL "https://git.io/tmpmail" > ~/bin/tmpmail && chmod +x ~/bin/tmpmail
}
install_utility_apps

print_header "Installing zsh plugins"

install_zsh_plugins() {
  print_arrow "fzf-marks"
  __get_local_zsh_plugin 'https://raw.githubusercontent.com/urbainvaes/fzf-marks/master/fzf-marks.plugin.zsh'
  print_arrow "zsh-nvm"
  __get_local_zsh_plugin 'https://raw.githubusercontent.com/lukechilds/zsh-nvm/master/zsh-nvm.plugin.zsh'
  local completion_date=$(curl -s "https://api.github.com/repos/zsh-users/zsh-completions/commits?path=src/_nvm&page=1&per_page=1" | jq -r '.[0].commit.committer.date')
  local my_completion=$(git log -1 --date=short --format="%ad" -- $(dirname "$0")/../nvm/.zsh-custom/completions/_nvm)
  if [[ $my_completion < $completion_date ]]; then print_warning "The completion file for '_nvm' seems outdated"; fi
  print_arrow "fast-syntax-highlighting"
  __clone_local_zsh_plugin 'https://github.com/zdharma-continuum/fast-syntax-highlighting.git'
  print_arrow "fzf-tab"
  __clone_local_zsh_plugin 'https://github.com/Aloxaf/fzf-tab.git'
}
install_zsh_plugins
