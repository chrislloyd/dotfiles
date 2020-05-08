# shell opts. see bash(1) for details
shopt -s cdspell
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s interactive_comments
shopt -u mailwarn
shopt -s no_empty_cmd_completion

source ~/.profile

source_maybe /usr/local/opt/nvm/etc/bash_completion
source_maybe $HOMEBREW_PREFIX/etc/bash_completion
source_maybe $HOME/.ktx-completion.sh
source_maybe $HOME/.bazelenv/versions/0.12.0rc3/lib/bazel/bin/bazel-complete.bash
source_maybe $HOME/.bazel/bin/bazel-complete.bash

if [ -d $HOME/src/arcanist ]; then
  source $HOME/src/arcanist/resources/shell/bash-completion
fi

PROMPT_COMMAND='__git_ps1 "\w" " \\\$ "'
