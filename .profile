#!/bin/sh

export EDITOR="code -w"
PATH=/usr/local/sbin:$PATH
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

s () {
  cd "$HOME/src/$1" || return
}

d () {
  cd "$HOME/Desktop/$1" || return
}

alias ..="cd .."
alias ...="cd ../.."

# homebrew
if [ -d /opt/homebrew ]
then
  export CPATH="/opt/homebrew/include"
  export LDFLAGS="-L/opt/homebrew/lib"
  export CPPFLAGS="-I/opt/homebrew/include"
  export LIBRARY_PATH="/opt/homebrew/lib"
fi

# deno
export DENO_INSTALL_ROOT="$HOME/.deno"
if [ -d "$DENO_INSTALL_ROOT" ]
then
  PATH="$DENO_INSTALL_ROOT/bin:$PATH"
fi

# cargo
. "$HOME/.cargo/env"

# python
PATH="$HOME/Library/Python/3.12/bin:$PATH"

# obsidian
export OBSIDIAN_VAULT_ID="69f2a33bbeb12d4b"

vault () {
  _path=$(jq ".vaults.\"$OBSIDIAN_VAULT_ID\".path" --raw-output < "$HOME/Library/Application Support/obsidian/obsidian.json")
  cd "$_path" || return
}

# cargo
. "$HOME/.cargo/env"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# bun
[ -s "/Users/chrislloyd/.bun/_bun" ] && source "/Users/chrislloyd/.bun/_bun"

# ghcup
[ -f "/Users/chrislloyd/.ghcup/env" ] && . "/Users/chrislloyd/.ghcup/env"
