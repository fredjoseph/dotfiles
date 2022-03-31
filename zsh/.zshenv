#!/bin/zsh

###############################
# EXPORT ENVIRONMENT VARIABLE #
###############################
export SHELL=/bin/zsh

# Don’t clear the screen after quitting a manual page.
export MANPAGER='less -X';
export PAGER=less

export RIPGREP_CONFIG_PATH=~/.ripgreprc

if [ -d "$HOME/bin" ]; then
  PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.local/bin" ]; then
  PATH="$PATH:$HOME/.local/bin"
fi

if [ -d "$HOME/bin/git" ]; then
  # $HOME must be used here ('~' doesn't work)
  PATH="$PATH:$HOME/bin/git"
fi

if [ -d "$HOME/.npm-global/bin" ]; then
  PATH="$PATH:$HOME/.npm-global/bin"
fi

if [ -d "$HOME/.yarn" ]; then
  PATH="$PATH:$HOME/.yarn-global/bin:$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin"
fi

if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

if [ -e "/etc/profile.d/apps-bin-path.sh" ]; then
    . /etc/profile.d/apps-bin-path.sh
fi

# WSL fixes
if grep -qE "(Microsoft|WSL)" /proc/version; then
  # Fix wrong permissions with mkdir command
  if [ "$(umask)" "==" '000' ]; then
    umask 0022
  fi

  # Fix '_z_precmd:1: nice(5) failed: operation not permitted'
  unsetopt BG_NICE
  # Access local X-server with VcXsrv
  export DISPLAY=:0
fi
