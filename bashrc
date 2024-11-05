# Git shortcuts
alias 'ga=git add'
alias 'gst=git st'
alias 'gc=git commit'
alias 'gca=git commit --amend'
alias 'glg=git lg'
# Aliases
alias 's=sudo'
alias 'mk=make -j`nproc`'
# Eternal bash history.
# ---------------------
# Undocumented feature which sets the size to "unlimited".
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT="[%F %T] "
# Change the file location because certain bash sessions truncate .bash_history file upon close.
export HISTFILE=~/.bash_eternal_history
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
