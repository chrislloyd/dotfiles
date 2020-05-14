# -- Personal

export EDITOR="code"

HOMEBREW_PREFIX=$(brew --prefix)

PATH=$PATH:/usr/local/bin
PATH=$PATH:/usr/local/sbin
PATH=$PATH:$HOME/bin

function s () { cd "$HOME/src/$1"; }
function d () { cd "$HOME/Desktop/$1"; }

alias ..="cd .."
alias ...="cd ../.."


# -- Tools

# Go
export GOPATH=$HOME
PATH=$PATH:$GOPATH/bin
PATH=$PATH:/usr/local/opt/go/libexec/bin

# Haskell
PATH=$PATH:$HOME/Library/Haskell/bin
PATH=$PATH:$HOME/.local/bin

# Javascript
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true
PATH=$PATH:`yarn global bin`

# OCaml
test -r /Users/chrislloyd/.opam/opam-init/init.sh && . /Users/chrislloyd/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true

# Python
PATH=$PATH:$HOME/Library/Python/3.7/bin
PATH=$PATH:$HOME/Library/Python/2.7/bin

# Ruby
export RBENV_ROOT=/usr/local/var/rbenv
export GEM_HOME=$HOME/.gem
eval "$(rbenv init -)"
PATH=$PATH:$GEM_HOME/bin

# Rust
PATH=$PATH:$HOME/.cargo/bin
