# zsh opts.
# http://zsh.sourceforge.net/Doc/Release/Options.html

setopt APPEND_HISTORY
setopt AUTOCD
setopt CORRECT
setopt EXTENDED_GLOB
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt INC_APPEND_HISTORY
setopt interactive_comments
setopt MAILWARN
setopt PROMPT_SUBST
setopt SHARE_HISTORY

SAVEHIST=5000
HISTSIZE=2000

# Load standard shell profile
[[ -e "${HOME}/.profile" ]] && source "${HOME}/.profile"

# Zgen
# https://github.com/tarjoilija/zgen

source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
	zgen load lukechilds/zsh-nvm
	zgen load zsh-users/zsh-syntax-highlighting
  zgen load unixorn/autoupdate-zgen
	zgen save
fi

# Homebrew
# https://brew.sh/

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Prompt
PS1='%F{240}%2~%f %(?.%F{240}.%F{red})%#%f '
