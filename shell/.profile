# -- Personal

export EDITOR="code"
PATH=/usr/local/sbin:$PATH

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
PATH=$PATH:$HOME/.local/bin

# Javascript
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

# Python
PATH=$PATH:$HOME/Library/Python/3.7/bin

# Ruby
export GEM_HOME=$HOME/.gem
PATH=$PATH:$GEM_HOME/bin

# Rust
PATH=$PATH:$HOME/.cargo/bin

