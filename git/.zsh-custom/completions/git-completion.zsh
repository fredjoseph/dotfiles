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
#  * git-flow-completion (https://github.com/bobthecow/git-flow-completion)
#
# ------------------------------------------------------------------------------

# Internal functions
# These are a lot like their __git_* equivalents inside _git

__gitex_command_successful () {
  if (( ${#*:#0} > 0 )); then
    _message 'not a git repository'
    return 1
  fi
  return 0
}

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

__gitex_tag_names() {
    local expl
    declare -a tag_names
    tag_names=(${${(f)"$(_call_program tags git for-each-ref --format='"%(refname)"' refs/tags 2>/dev/null)"}#refs/tags/})
    __git_command_successful || return
    _wanted tag-names expl tag-name compadd $* - $tag_names
}


__gitex_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads 2>/dev/null)"}#refs/heads/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd $* - $branch_names
}

__gitex_specific_branch_names() {
    local expl
    declare -a branch_names
    branch_names=(${${(f)"$(_call_program branchrefs git for-each-ref --format='"%(refname)"' refs/heads/"$1" 2>/dev/null)"}#refs/heads/$1/})
    __git_command_successful || return
    _wanted branch-names expl branch-name compadd - $branch_names
}

__gitex_feature_branch_names() {
    __gitex_specific_branch_names 'feature'
}

__gitex_submodule_names() {
    local expl
    declare -a submodule_names
    submodule_names=(${(f)"$(_call_program branchrefs git submodule status | awk '{print $2}')"})  # '
    __git_command_successful || return
    _wanted submodule-names expl submodule-name compadd $* - $submodule_names
}

__gitex_author_names() {
    local expl
    declare -a author_names
    author_names=(${(f)"$(_call_program branchrefs git log --format='%aN' | sort -u)"})
    __git_command_successful || return
    _wanted author-names expl author-name compadd $* - $author_names
}

# subcommands
# new subcommand should be added in alphabetical order
_git-authors() {
    _arguments  -C \
        '(--list -l)'{--list,-l}'[show authors]' \
        '--no-email[without email]' \
}

_git-changelog() {
    _arguments \
        '(-l --list)'{-l,--list}'[list commits]' \
}

_git-coauthor() {
    _arguments \
        ':co-author[co-author to add]' \
        ':co-author-email[email address of co-author to add]'
}

_git-contrib() {
    _arguments \
        ':author:__gitex_author_names'
}


_git-count() {
    _arguments \
        '--all[detailed commit count]'
}

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

_git-delete-branch() {
    _arguments \
        ':branch-name:__gitex_branch_names'
}


_git-delete-submodule() {
    _arguments \
        ':submodule-name:__gitex_submodule_names'
}


_git-delete-tag() {
    _arguments \
        ':tag-name:__gitex_tag_names'
}


_git-effort() {
    _arguments \
        '--above[ignore file with less than x commits]'
}


_git-extras() {
    local curcontext=$curcontext state line ret=1
    declare -A opt_args

    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument' && ret=0

    case $state in
        (command)
            declare -a commands
            commands=(
                'update:update git-extras'
            )
            _describe -t commands command commands && ret=0
            ;;
    esac

    _arguments \
        '(-v --version)'{-v,--version}'[show current version]'
}


_git-feature() {
    local curcontext=$curcontext state line ret=1
    declare -A opt_args

    _arguments -C \
        ': :->command' \
        '*:: :->option-or-argument' && ret=0

    case $state in
        (command)
            declare -a commands
            commands=(
                'finish:merge feature into the current branch'
            )
            _describe -t commands command commands && ret=0
            ;;
        (option-or-argument)
            curcontext=${curcontext%:*}-$line[1]:
            case $line[1] in
                (finish)
                    _arguments -C \
                        '--squash[Use squash merge]' \
                        ':branch-name:__gitex_feature_branch_names'
                    ;;
                -r|--remote )
                    _arguments -C \
                        ':remote-name:__gitex_remote_names'
                    ;;
            esac
            return 0
    esac

    _arguments \
        '(--remote -r)'{--remote,-r}'[setup remote tracking branch]'
}

_git-graft() {
    _arguments \
        ':src-branch-name:__gitex_branch_names' \
        ':dest-branch-name:__gitex_branch_names'
}

_git-guilt() {
    _arguments -C \
        '(--email -e)'{--email,-e}'[display author emails instead of names]' \
        '(--ignore-whitespace -w)'{--ignore-whitespace,-w}'[ignore whitespace only changes]' \
        '(--debug -d)'{--debug,-d}'[output debug information]' \
        '-h[output usage information]'
}

_git-ignore() {
    _arguments -C \
        '(--local -l)'{--local,-l}'[show local gitignore]' \
        '(--global -g)'{--global,-g}'[show global gitignore]' \
        '(--private -p)'{--private,-p}'[show repo gitignore]'
}


_git-info() {
    _arguments -C \
        '(--color -c)'{--color,-c}'[use color for information titles]' \
        '--no-config[do not show list all variables set in config file, along with their values]'
}


_git-merge-into() {
    _arguments '--ff-only[merge only fast-forward]'
    _arguments \
        ':src:__gitex_branch_names' \
        ':dest:__gitex_branch_names'
}

_git-missing() {
    _arguments \
        ':first-branch-name:__gitex_branch_names' \
        ':second-branch-name:__gitex_branch_names'
}

_git-release() {
    _arguments -C \
        '-c[Generates/populates the changelog with all commit message since the last tag.]' \
        '-r[The "remote" repository that is destination of a push operation.]' \
        '-m[use the custom commit information instead of the default message.]' \
        '-s[Create a signed and annotated tag.]' \
        '-u[Create a tag, annotated and signed with the given key.]' \
        '--semver[If the latest tag in your repo matches the semver format requirement, you could increase part of it as the new release tag.]' \
        '--no-empty-commit[Avoid creating empty commit if nothing could be committed.]' \
        '--[The arguments listed after "--" separator will be passed to pre/post-release hook.]'
}

_git-squash() {
    _arguments '--squash-msg[commit with the squashed commit messages]'
    _arguments \
        ':branch-name:__gitex_branch_names'
}

_git-stamp() {
    _arguments -C \
         '(--replace -r)'{--replace,-r}'[replace stamps with same id]'
}

_git-standup() {
    _arguments -C \
        '-a[Specify the author of commits. Use "all" to specify all authors.]' \
        '-d[Show history since N days ago]' \
        '-D[Specify the date format displayed in commit history]' \
        '-f[Fetch commits before showing history]' \
        '-g[Display GPG signed info]' \
        '-h[Display help message]' \
        '-L[Enable the inclusion of symbolic links]' \
        '-m[The depth of recursive directory search]' \
        '-B[Display the commits in branch groups]'
}

_git-summary() {
    _arguments '--line[summarize with lines rather than commits]'
    _arguments '--dedup-by-email[remove duplicate users by the email address]'
    __gitex_commits
}

_git-undo(){
    _arguments -C \
        '(--soft -s)'{--soft,-s}'[only rolls back the commit but changes remain un-staged]' \
        '(--hard -h)'{--hard,-h}'[wipes your commit(s)]'
}

zstyle -g existing_user_commands ':completion:*:*:git:*' user-commands

zstyle ':completion:*:*:git:*' user-commands $existing_user_commands \
    f_add:'git add/restore - powered by fzf' \
    f_cherry-pick:'git cherry-pick - powered by fzf' \
    f_log:'git log - powered by fzf' \
    f_stash:'git stash - powered by fzf' \
    f_rebase:'git rebase - powered by fzf' \
    f_checkout:'git checkout - powered by fzf' \
    ignore-io:'get sample gitignore file' \
    jump:'jump to another branch - powered by fzf' \
    missing:'show commits missing from another branch' \
    recent:'checkout on recent branches - powered by fzf' \
    unstage:'unstage changes - powered by fzf'