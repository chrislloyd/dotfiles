export EDITOR="code -w"
PATH=/usr/local/sbin:$PATH

function s () { cd "$HOME/src/$1"; }
function d () { cd "$HOME/Desktop/$1"; }

alias ..="cd .."
alias ...="cd ../.."

PATH="$HOME/bin:$PATH"
