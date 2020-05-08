# source_maybe - optionally source files if they exist
function source_maybe () {
    [ -s $1 ] && source $1
}

HOMEBREW_PREFIX=$(brew --prefix)

export EDITOR="emacs"

# Ruby
export RBENV_ROOT=/usr/local/var/rbenv
export GEM_HOME=$HOME/.gem

# Go
export GOPATH=$HOME

# OCaml
test -r /Users/chrislloyd/.opam/opam-init/init.sh && . /Users/chrislloyd/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# NodeJS
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

# Ruby
eval "$(rbenv init -)"


PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:$GOPATH/bin
PATH=$PATH:$HOME/Library/Haskell/bin
PATH=$PATH:`yarn global bin`
PATH=$PATH:$HOME/.cargo/bin
PATH=$PATH:$HOME/node_modules/.bin
PATH=$PATH:$HOME/bin
PATH=$PATH:$GEM_HOME/bin
PATH=$PATH:$HOME/src/chrislloyd/bin
PATH=$PATH:/usr/local/opt/go/libexec/bin
PATH=$PATH:$HOME/Library/Python/3.7/bin
PATH=$PATH:$HOME/Library/Python/2.7/bin
PATH=$PATH:$HOME/bin

# Arcanist
if [ -d $HOME/src/arcanist ]; then
  PATH=$PATH:$HOME/src/arcanist/bin
fi

function s () { cd "$HOME/src/$1"; }
function d () { cd "$HOME/Desktop/$1"; }

alias ..="cd .."
alias ...="cd ../.."
