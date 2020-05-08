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

source "${HOME}/.zgen/zgen.zsh"

# if the init script doesn't exist
if ! zgen saved; then

  # specify plugins here
  zgen load lukechilds/zsh-nvm
  zgen load zsh-users/zsh-syntax-highlighting

  # generate the init script from plugins above
  zgen save
fi

[[ -e ~/.profile ]] && source ~/.profile

if type brew &>/dev/null; then
  FPATH=$HOMEBREW_PREFIX/share/zsh/site-functions:$FPATH
fi
