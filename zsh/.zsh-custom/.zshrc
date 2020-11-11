export FZF_MARKS_COMMAND="fzf --height 40% --reverse -n 1 -d ' : '"
export BAT_PAGER="less -iRX"

#FIXME : verif usage
function pet-select() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-select
stty -ixon
bindkey '^s' pet-select

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;33m'       # begin blinking
export LESS_TERMCAP_md=$'\e[1;33m'       # begin bold
export LESS_TERMCAP_us=$'\e[4;36m'       # begin underline
export LESS_TERMCAP_so=$'\e[30;47m'      # begin standout-mode - info box
export LESS_TERMCAP_me=$'\e[m'           # end mode
export LESS_TERMCAP_ue=$'\e[m'           # end underline
export LESS_TERMCAP_se=$'\e[m'           # end standout-mode