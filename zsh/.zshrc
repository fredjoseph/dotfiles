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
#   ZSH Plugins & Completions Configuration
#------------------------------------------------------------------
source ${MY_ZSH_CUSTOM}/.plugins

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

eval "$(zoxide init zsh --no-aliases)"

# Local customizations (not stored in git)
_include ${MY_ZSH_CUSTOM}/local/.zshrc

#------------------------------------------------------------------
#   Cleanup
#------------------------------------------------------------------
# Remove duplicate entries
typeset -gU path