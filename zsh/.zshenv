#!/bin/zsh

skip_global_compinit=1

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

if [ -d "$HOME/bin/git" ]; then
  PATH="$PATH:$HOME/bin/git"
fi

if [ -d "$HOME/.npm-global/bin" ]; then
  PATH="$PATH:$HOME/.npm-global/bin"
fi

if [ -d "$HOME/.yarn" ]; then
  PATH="$PATH:~/.yarn-global/bin:~/.yarn/bin:~/.config/yarn/global/node_modules/.bin"
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