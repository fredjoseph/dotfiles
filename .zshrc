# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="avit"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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
#   Plugins
#------------------------------------------------------------------

# Standard common plugins
plugins=(git colored-man-pages common-aliases extract tmux)

# additional plugins
export NVM_LAZY_LOAD=true
export NVM_DIR="$HOME/.nvm"

plugins+=(debian docker docker-compose autojump zsh-syntax-highlighting k zsh-nvm zsh-better-npm-completion yarn)

source $ZSH/oh-my-zsh.sh

#------------------------------------------------------------------
#   User configuration
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

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

export PATH="$PATH:~/.yarn-global/bin:~/.yarn/bin:~/.config/yarn/global/node_modules/.bin"
export SHELL=/bin/zsh

# add a function path
fpath=(~/.zsh-custom.d/functions $fpath)

# Scripts
#--------

# nvm
#export NVM_LAZY_LOAD=true
#export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# zsh-bd
[ -f $ZSH/custom/plugins/bd/bd.zsh ] && source $ZSH/custom/plugins/bd/bd.zsh

# fzf
if [ -f ~/.fzf.zsh ]; then
	# Exclude those directories even if not listed in .gitignore, or if .gitignore is missing
	FD_OPTIONS="--follow --exclude .git --exclude node_modules"
	# Change FZF behavior
	export FZF_DEFAULT_OPTS="--no-mouse --height 50% -1 --reverse --multi --inline-info --preview='[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (bat --style=numbers --color=always {} || cat {}) 2> /dev/null | head -300' --preview-window='right:hidden:wrap' --bind='f3:execute(bat --style=numbers {} || less -f {}),f2:toggle-preview,ctrl-d:half-page-down,ctrl-u:half-page-up,ctrl-a:select-all+accept,ctrl-y:execute-silent(echo {+} | pbcopy)'"
	# Change find backend (use 'git ls-files' when git repo, otherwise 'fd')
	export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l "
	export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
	export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
	source ~/.fzf.zsh
fi

# Load zsh completions
if [ -d ~/.zsh-custom.d/completions ]; then
	for file in ~/.zsh-custom.d/completions/*; do
		. $file
	done
fi

#typeset -aU fpath

# Aliases
#--------
# Defaults bindings
#		alias 	list all aliases
#		.. 	cd ..
#		... 	cd ../..
#		.... 	cd ../../..
#		..... 	cd ../../../..
#		/ 	cd /
#		~ 	cd ~
#		cd +n 	switch to directory number n
#		1 	cd -
#		2 	cd -2
#		3 	cd -3
#		4 	cd -4
#		5 	cd -5
#		6 	cd -6
#		7 	cd -7
#		8 	cd -8
#		9 	cd -9
#		md 	mkdir -p
#		rd 	rmdir
#		d 	dirs -v (lists last used directories)
#
#		ta	tmux attach -t
#		tad	tmux attach -d -t
#		ts	tmux new-session -s
#		tl	tmux list-sessions
#		tksv	tmux kill-server
#		tkss	tmux kill-session -t
#
#		Ctrl-_	Undo
#		Ctrl-@	Set mark command
#		Ctrl-a	Beginning of line
#		Ctrl-b	Backward char
#		Ctrl-d	Delete char or list
#		Ctrl-e	End of line
#		Ctrl-f	Forward char
#		Ctrl-g	Send break
#		Ctrl-h	Backward delete char
#		Ctrl-j	Accept line
#		Ctrl-k	Kill line
#		Ctrl-l	Clear screen
#		Ctrl-m	Accept line
#		Ctrl-n	Down line or history
#		Ctrl-o	Accept line and down history
#		Ctrl-p	Up line or history
#		Ctrl-q	Push line
#		Ctrl-r	FZF history search
#		Ctrl-s	History incremental search forward
#		Ctrl-t	FZF File search
#		Ctrl-u	Kill whole line
#		Ctrl-v	Quoted insert
#		Ctrl-w Backward kill word
#		Ctrl-× Ctrl-e	Edit command line in vim
#		Ctrl-x Ctrl-x	Exchange point and mark
#		Ctrl-x c	Correct word
#		Ctrl-x m	Most recent file
#		Ctrl-x r	History incremental search backward
#		Ctrl-x s	History incremental search forward
#		Ctrl-Alt-h	Backward kill word
#		Alt-'		Quote line
#		Alt-a		Accept and hold
#		Alt-b		Backward word
#		Alt-c		Capitalize word
#		Alt-f		Forward word
#		Alt-h		Run help
#		Alt-l		Run command ls
#		Alt-p		History search backward
#		Alt-q		Push line
#		Alt-t		Transpose words
#
#	Default functions
#		take			create a new directory and change to it, will create intermediate directories as required
#		x/extract		extract an archive
#		zsh_stats		get a list of the top 20 commands and how many times they have been run
#		upgrade_oh_my_zsh	Upgrade Oh-my-zsh
#		uninstall_oh_my_zsh	Uninstall Oh-my-zsh
#		alias_value		Get the value of an alias
#		omz_urlencode		URL-encode a string (RFC 2396)
#		omz_urldecode		URL-decode a string (RFC 2396)

# Global aliases
alias tmux="tmux -2 -u" # force 256 colors AND UTF-8
alias less="less -M" # verbose prompt

# Custom aliases
[ -f ~/.zsh-custom.d/aliases ] && source ~/.zsh-custom.d/aliases
