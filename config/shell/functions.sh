# Shared shell functions (sourced by bash and zsh)

# Quick jump to code directory
s() {
  cd ~/code/"$1" || return
}

# Jump to Obsidian vault
vault() {
  _path=$(jq ".vaults.\"$OBSIDIAN_VAULT_ID\".path" --raw-output < "$HOME/Library/Application Support/obsidian/obsidian.json")
  cd "$_path" || return
}
