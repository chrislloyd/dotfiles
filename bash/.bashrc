# shell opts. see bash(1) for details
shopt -s cdspell
shopt -s extglob
shopt -s histappend
shopt -s hostcomplete
shopt -s interactive_comments
shopt -u mailwarn
shopt -s no_empty_cmd_completion

# Load standard shell profile
[[ -e "${HOME}/.profile" ]] && source "${HOME}/.profile"
