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
  for FILE in $(find "$1" -xtype f -print 2>/dev/null); do
    source $FILE
  done
}

#------------------------------------------------------------------
#   OH-MY-ZSH Configuration
#------------------------------------------------------------------

# Standard common plugins
plugins=(git zsh-syntax-highlighting common-aliases extract tmux zsh_reload)
plugins+=(docker docker-compose fd)
# Include configuration specific to the local environment (corresponding to the current git branch)
_include ${MY_ZSH_CUSTOM}/.oh-my-zsh

source $ZSH/oh-my-zsh.sh

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

# ZSH Completions
#----------------
# By convention, file starting with "_" should contain "compdef" at first line and will be managed directly by zsh through fpath
if [ -d ~/.zsh-custom/completions ]; then
	for file in ~/.zsh-custom/completions/[^_]*(N); do
		. $file
	done
    unset file
fi

fpath=($MY_ZSH_CUSTOM/completions $fpath)

# ZSH Plugins
#------------
for config_file ($ZSH_CUSTOM/**/*.plugin.zsh(N)); do
  source $config_file
done
unset config_file

# Reload the completions
autoload -U compinit && compinit

# Others
#-------
# Activate "autocutsel" only if X server detected
if pgrep Xorg >&/dev/null; then
	autocutsel -selection PRIMARY -fork
	autocutsel -fork
fi

#------------------------------------------------------------------
#   Aliases and Functions
#------------------------------------------------------------------
_include ${MY_ZSH_CUSTOM}/aliases
_include ${MY_ZSH_CUSTOM}/functions

#------------------------------------------------------------------
#   Local Configuration -- should be last!
#------------------------------------------------------------------
# - configuration specific to the local environment (corresponding to the current git branch)
# TODO: To Remove
_include ${MY_ZSH_CUSTOM}/.zshrc
# - to add private customizations, create '${MY_ZSH_CUSTOM}/private/.zshrc' and add changes to it
_include ${MY_ZSH_CUSTOM}/private/.zshrc
