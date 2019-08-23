export EDITOR="vim"
export VISUAL="vim"
export XZ_OPT="-9"                      # best compression for tar.xz creation
export LC_ALL="en_US.UTF-8"             # use UTF-8 character set
export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export CLICOLOR=1                       # use colors (if possible)
export STDERR_COLOR="\033[31m"          # make stderr output red
export HISTTIMEFORMAT="[%Y-%m-%d %T] "  # timestamp history commands
export HISTCONTROL="ignoredups"         # dont record duplicate commands
export HISTIGNORE="&:ls:cd:[bf]g:exit"  # dont record simple commands like ls

if [ -n "$TMUX" ]; then
	export TERM='screen-256color'
else
	export TERM='xterm-256color'
fi

# Enable a better reverse search experience.
#   Requires: https://github.com/junegunn/fzf (to use fzf in general)
#   Requires: https://github.com/BurntSushi/ripgrep (for using rg below)
export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --glob '!.git'"
[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

# WSL (Windows Subsystem for Linux) specific settings.
if grep -qE "(Microsoft|WSL)" /proc/version; then
	# Adjustments for WSL's file / folder permission metadata.
	if [ "$(umask)" == "0000" ]; then
		umask 0022
	fi

	# Access local X-server with VcXsrv.
	#   Requires: https://sourceforge.net/projects/vcxsrv/ (or alternative)
	export DISPLAY=:0
fi

# ----------------------------------------------------------------------------
# Bindings
# Default bindings :
#   Ctrl-a: beginnning-of-line
#   Ctrl-r: end-of-line
#   Ctrl-space: set mark
#   Ctrl-x-x: exchange-point-and-mark (by default switch between the beginning and the end of the line)
#   Ctrl-n: kill-whole-line
#   Ctrl-k: previous-history
#   Ctrl-j: next-history
# ----------------------------------------------------------------------------

bind "set completion-ignore-case     on"

shopt -s cmdhist                        # make multiline commands stay together
shopt -s lithist                        # history newlines rather than semicolons
shopt -s histappend                     # append to history instead of rewriting
shopt -s dotglob                        # include hidden files with cp, mv, etc.

# ----------------------------------------------------------------------------
# Aliases
# ----------------------------------------------------------------------------
alias tmux="tmux -2 -u" # force 256 colors AND UTF-8
alias ls="ls --color=auto -v -h --group-directories-first"
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias grep="grep --color=auto"
alias fgrep="fgrep --color=auto"
alias egrep="egrep --color=auto"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# ----------------------------------------------------------------------------
# Functions
# ----------------------------------------------------------------------------
function cleanenv(){
	if [ $# -ne 0 ]; then

		env -i \
			HOME=\"$HOME\" \
			PATH=\"$PATH\" \
			LD_LIBRARY_PATH=\"$LD_LIBRARY_PATH\"
		USER=\"$USER\" \
			bash --norc --noprofile -c $@
	else
		echo "Usage: cleanenv <program> [arglist]" 1>&2
	fi
}

# local and remote ip addresses
function localip(){
	hostname -I | awk '{print $1}'
}

function remoteip(){
	curl watismijnip.nl 2>/dev/null | grep -io "ipadress:\ [^\ ^<]*" | awk -F' ' '{print $2}'
}

# list all options used by bash
function options(){
	(shopt && set -o && bind -v | sed 's:^set::') | column -t | nl
}

# print date
function now(){
	date '+%Y-%m-%d %H:%M:%S'
}

# extract files
function extract() {
	if [ -f "$@" ] ; then
		case "$@" in
			*.tar.bz2)  tar xvjf "$@" ;;
			*.tar.gz)   tar xvzf "$@" ;;
			*.tar.xz)   tar Jxvf "$@" ;;
			*.bz2)      bunzip2 "$@" ;;
			*.rar)      unrar x "$@" ;;
			*.gz)       gunzip "$@" ;;
			*.tar)      tar xvf "$@" ;;
			*.tbz2)     tar xvjf "$@" ;;
			*.tgz)      tar xvzf "$@" ;;
			*.zip)      unzip "$@" ;;
			*.Z)        uncompress "$@" ;;
			*.7z)       7z x "$@" ;;
			*)      echo "don't know how to extract '$@'..." ;;
		esac
	else
		echo "'$@' is not a valid file!"
	fi
}


# create dir and go into it
mkcd() {
	mkdir -p "$@"
	cd "$@"
}
