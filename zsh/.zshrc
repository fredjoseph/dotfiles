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
  [[ -e $1 ]] && . $1
}

#------------------------------------------------------------------
#   OH-MY-ZSH Plugins
#------------------------------------------------------------------

# Standard common plugins
plugins=(git colored-man-pages common-aliases extract tmux zsh_reload tig)
plugins+=(debian docker docker-compose autojump fd)
_include ${MY_ZSH_CUSTOM}/.oh-my-zsh_local

source $ZSH/oh-my-zsh.sh

#------------------------------------------------------------------
#   ZSH User Configuration
#------------------------------------------------------------------

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

#------------------------------------------------------------------
#   Externals
#------------------------------------------------------------------
_include ${MY_ZSH_CUSTOM}/aliases
_include ${MY_ZSH_CUSTOM}/functions
_include ${MY_ZSH_CUSTOM}/completions/general.sh
_include ${MY_ZSH_CUSTOM}/**/*.plugin.zsh

# add a function path (https://github.com/jmervine/zshrc/blob/master/completion/general.sh - a déplacer dans general.sh voir si même dossier pour general.sh que pour les compdef)
fpath=($MY_ZSH_CUSTOM/functions $fpath)

# Reload the completion
autoload -U compinit && compinit

#------------------------------------------------------------------
#   Common Configuration
#------------------------------------------------------------------

# FZF
if [ $(command -v "fzf") ]; then
    # Exclude those directories even if not listed in .gitignore, or if .gitignore is missing
	FD_OPTIONS="--follow --exclude .git --exclude node_modules"
	# Change FZF behavior
	export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
	# Change find backend (use 'git ls-files' when git repo, otherwise 'fd')
	export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l --hidden --exclude .git"
	export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
	export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
    source ~/.fzf.zsh
fi

# Load zsh completions
if [ -d ~/.zsh-custom.d/completions ]; then
	for file in ~/.zsh-custom.d/completions/*(.N); do
		. $file
	done
fi

#------------------------------------------------------------------
#   Local Configuration -- should be last!
#------------------------------------------------------------------
# - to add local customizations, create '~/.zshrc_local' and add changes to it
_include ~/.zshrc_local

# Scripts
#--------


# zsh-bd
[ -f $ZSH/custom/plugins/bd/bd.zsh ] && source $ZSH/custom/plugins/bd/bd.zsh
