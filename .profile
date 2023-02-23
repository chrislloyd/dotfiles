#!/bin/sh

export EDITOR="code -w"
PATH=/usr/local/sbin:$PATH
PATH="$HOME/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

s () {
  cd "$HOME/src/$1" || return
}

d () {
  cd "$HOME/Desktop/$1" || return
}

alias ..="cd .."
alias ...="cd ../.."

# ruby
PATH="/opt/homebrew/opt/ruby/bin:$PATH"
if [ -d /opt/homebrew/opt/ruby ]
then
  export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
fi

# deno
export DENO_INSTALL_ROOT="$HOME/.deno"
if [ -d "$DENO_INSTALL_ROOT" ]
then
  PATH="$DENO_INSTALL_ROOT/bin:$PATH"
fi
