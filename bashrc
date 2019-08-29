# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


# Git shortcuts
alias 'ga=git add'
alias 'gst=git st'
alias 'gc=git commit'
alias 'gca=git commit --amend'
alias 'glg=git lg'
# Aliases
alias 'gpg-newcard=gpg-connect-agent "scd serialno"  "learn --force" /bye'
alias 's=sudo'
alias 'mk=make -j`nproc`'
# Alias gerrit-init to set up Change-Id hook
alias 'k=cd $(git rev-parse --show-cdup)'
# History
shopt -s histappend
export HISTFILESIZE=
export HISTSIZE=
# GPG
export GPG_TTY=$(tty)
