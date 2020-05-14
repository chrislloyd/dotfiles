[[ -e ~/.profile ]] && source ~/.profile

setopt EXTENDED_GLOB
setopt interactive_comments
setopt MAILWARN
setopt PROMPT_SUBST
setopt AUTOCD
setopt CORRECT

# History

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS

SAVEHIST=5000
HISTSIZE=2000

# Zgen
# https://github.com/tarjoilija/zgen

source "${HOME}/.zgen/zgen.zsh"
if ! zgen saved; then
	zgen load lukechilds/zsh-nvm
	zgen load zsh-users/zsh-syntax-highlighting
	zgen save
fi

# Homebrew
# https://brew.sh/

if type brew &>/dev/null; then
  FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
fi

# Prompt
PS1='%(?.%F{240}.%F{red})%B%2~%b %# '
