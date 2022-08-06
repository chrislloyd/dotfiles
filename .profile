#!/bin/sh

export EDITOR="code -w"
PATH=/usr/local/sbin:$PATH

s () {
  cd "$HOME/src/$1" || return
}

d () {
  cd "$HOME/Desktop/$1" || return
}

alias ..="cd .."
alias ...="cd ../.."

PATH="$HOME/bin:$PATH"
