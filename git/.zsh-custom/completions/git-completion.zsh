# ------------------------------------------------------------------------------
# Description
# -----------
#
#  Completion script for git
#
# ------------------------------------------------------------------------------
# Inspirations
# -----------
#
#  * git-extras (https://github.com/tj/git-extras)
#
# ------------------------------------------------------------------------------

# Internal functions
# These are a lot like their __git_* equivalents inside _git

__gitex_commits() {
    declare -A commits
    git log --oneline -15 | sed 's/\([[:alnum:]]\{7\}\) /\1:/' | while read commit
    do
        hash=$(echo $commit | cut -d':' -f1)
        commits[$hash]="$commit"
    done
    local ret=1
    _describe -t commits commit commits && ret=0
}

__gitex_remote_names() {
    local expl
    declare -a remote_names
    remote_names=(${(f)"$(_call_program remotes git remote 2>/dev/null)"})
    __git_command_successful || return
    _wanted remote-names expl remote-name compadd $* - $remote_names
}

__gitex_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}

# subcommands
# new subcommand should be added in alphabetical order

_git-create-branch() {
    local curcontext=$curcontext state line
    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument'

    case "$state" in
        (command)
            _arguments \
                '(--remote -r)'{--remote,-r}'[setup remote tracking branch]'
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*}-$line[1]:
            case $line[1] in
                -r|--remote )
                    _arguments -C \
                        ':remote-name:__gitex_remote_names'
                    ;;
            esac
    esac
}

_git-effort() {
    _arguments \
        '--above[ignore file with less than x commits]'
}

_git-guilt() {
    _arguments -C \
        '(--email -e)'{--email,-e}'[display author emails instead of names]' \
        '(--ignore-whitespace -w)'{--ignore-whitespace,-w}'[ignore whitespace only changes]' \
        '(--debug -d)'{--debug,-d}'[output debug information]' \
        '-h[output usage information]'
}

_git-info() {
    _arguments -C \
        '(--color -c)'{--color,-c}'[use color for information titles]' \
        '--no-config[do not show list all variables set in config file, along with their values]'
}

_git-jump() {
   _arguments \
        ':branch:__gitex_branch_names'
}

_git-missing() {
    _arguments \
        ':first-branch-name:__gitex_branch_names' \
        ':second-branch-name:__gitex_branch_names'
}

_git-summary() {
    _arguments '--line[summarize with lines rather than commits]'
    _arguments '--dedup-by-email[remove duplicate users by the email address]'
}

_git-squash() {
    _arguments '--squash-msg[commit with the squashed commit messages]'
    _arguments \
        ':branch-name:__gitex_branch_names'
}

_git-undo(){
    _arguments \
        '2:mode (mixed, soft, hard):(mixed soft hard)'
}

zstyle -g existing_user_commands ':completion:*:*:git:*' user-commands

zstyle ':completion:*:*:git:*' user-commands $existing_user_commands \
    f_add:'git add/restore - powered by fzf' \
    f_checkout:'git checkout - powered by fzf' \
    f_cherry-pick:'git cherry-pick - powered by fzf' \
    f_log:'git log - powered by fzf' \
    f_stash:'git stash - powered by fzf' \
    f_rebase:'git rebase - powered by fzf' \
    f_revert:'git revert - powered by fzf' \
    f_unstage:'unstage changes - powered by fzf' \
    archive-file:'export the current head of the git repository to an archive' \
    create-branch:'create branches' \
    effort:'show effort statistics on file(s)' \
    guilt:'calculate change between two revisions' \
    ignore-io:'get sample gitignore file' \
    info:'returns information on current repository' \
    jump:'jump to another branch - powered by fzf' \
    missing:'show commits missing from another branch' \
    recent:'checkout on recent branches - powered by fzf' \
    summary:'show repository summary' \
    squash:'import changes from a branch'