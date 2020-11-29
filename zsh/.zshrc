# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

#------------------------------------------------------------------
#   Common
#------------------------------------------------------------------
test "$MY_ZSH_CUSTOM" || MY_ZSH_CUSTOM=~/.zsh-custom

function _include() {
  for file in $(find "$1" -xtype f -print 2>/dev/null); do
    source $file
  done
  unset file
}

#------------------------------------------------------------------
#   OH-MY-ZSH Configuration
#------------------------------------------------------------------

# Plugins
#--------
plugins=(command-not-found common-aliases docker docker-compose extract fd git tmux)

# Environment specific
plugins+=(debian yarn mvn)

# Customization
#--------------
# This speeds up pasting
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish


source $ZSH/oh-my-zsh.sh

#------------------------------------------------------------------
#   ZSH Plugins & Completions
#------------------------------------------------------------------
source ${MY_ZSH_CUSTOM}/plugins

# Reload the completions
autoload -U compinit
if [[ -n "${ZSH_COMPDUMP}"(#qN.mh+24) ]]; then
      compinit
      compdump
else
      compinit -C
fi

#------------------------------------------------------------------
#   Aliases and Functions
#------------------------------------------------------------------
source ${MY_ZSH_CUSTOM}/aliases
source ${MY_ZSH_CUSTOM}/functions

#------------------------------------------------------------------
#   Common Configuration
#------------------------------------------------------------------

# FZF
#----
if ! [ $(command -v "fzf") ] && [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
fi
if [ $(command -v "fzf") ]; then
    # Exclude those directories even if not listed in .gitignore, or if .gitignore is missing
	FD_OPTIONS="--follow --exclude .git --exclude node_modules"
	# Change FZF behavior
    export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --inline-info --preview='([[ -d {} ]] && tree -C {}) || ([[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file) || (bat --file-name={} --color=always {} || less -f {}) 2>/dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(([[ -d {} ]] && less -f <(tree -C {}) >/dev/tty 2>&1) || bat --style=numbers {} >/dev/tty 2>&1 || less -f {} >/dev/tty 2>&1),f2:toggle-preview,ctrl-j:preview-down,ctrl-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,ctrl-q:abort,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | xclip)'"
	# Change find backend (use 'git ls-files' when git repo, otherwise 'fd')
	export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l --hidden $FD_OPTIONS"
	export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
	export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
fi

#------------------------------------------------------------------
#   Local Configuration
#------------------------------------------------------------------

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;33m'       # begin blinking
export LESS_TERMCAP_md=$'\e[1;33m'       # begin bold
export LESS_TERMCAP_us=$'\e[4;36m'       # begin underline
export LESS_TERMCAP_so=$'\e[30;47m'      # begin standout-mode - info box
export LESS_TERMCAP_me=$'\e[m'           # end mode
export LESS_TERMCAP_ue=$'\e[m'           # end underline
export LESS_TERMCAP_se=$'\e[m'           # end standout-mode

# Activate "autocutsel" only if X server detected
if pgrep Xorg >&/dev/null; then
	autocutsel -selection PRIMARY -fork
	autocutsel -fork
fi

export FZF_MARKS_COMMAND="fzf --height 40% --reverse -n 1 -d ' : '"
export BAT_PAGER="less -iRX"

# List all snippets with 'ctrl-s'
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select

# Private customizations (not stored in git)
_include ${MY_ZSH_CUSTOM}/private/.zshrc

#------------------------------------------------------------------
#   Cleanup
#------------------------------------------------------------------
# Remove duplicate entries
typeset -gU path fpath