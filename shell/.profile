# -- Personal

export EDITOR="code -w"
PATH=/usr/local/sbin:$PATH

function s () { cd "$HOME/src/$1"; }
function d () { cd "$HOME/Desktop/$1"; }

alias ..="cd .."
alias ...="cd ../.."

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi


# -- Tools

# Go
export GOPATH=$HOME
PATH=$PATH:$GOPATH/bin
PATH=$PATH:/usr/local/opt/go/libexec/bin

# Javascript
export NVM_LAZY_LOAD=true
export NVM_AUTO_USE=true

# Python
PATH=$PATH:$HOME/Library/Python/3.7/bin

# Ruby
export GEM_HOME=$HOME/.gem
PATH=$PATH:$GEM_HOME/bin
PATH=/usr/local/opt/ruby/bin:$PATH
export LDFLAGS="-L/usr/local/opt/ruby/lib"
export CPPFLAGS="-I/usr/local/opt/ruby/include"
export PKG_CONFIG_PATH="/usr/local/opt/ruby/lib/pkgconfig"

# Rust
PATH=$PATH:$HOME/.cargo/bin

