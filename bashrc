# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac


source ~/dotfiles/scripts/upstream.sh
alias gp='goto-proj'
alias ue='vi ~/dotfiles/scripts/upstream.conf'
alias pa='goto-patches'
# Git shortcuts
alias 'ga=git add'
alias 'gst=git st'
alias 'gc=git commit'
alias 'gca=git commit --amend'
alias 'glg=git lg'
# Aliases
alias 'remove-change-id=sed -i "/^Change-Id/d"'
alias 'gpg-change-card=gpg-connect-agent "scd serialno"  "learn --force" /bye'
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
