# Alias
alias ecommit='git commit --allow-empty -m "empty commit"'
alias bucc='brew upgrade claude-code@latest'

# Local bin: User scripts
export PATH="$HOME/.local/bin:$PATH"

# Kiro: Shell integration
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Antigravity: CLI tools
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Homebrew: Auto-update Brewfile after install/uninstall/tap/untap
brew() {
  command brew "$@"
  if [[ "$1" =~ ^(install|uninstall|tap|untap)$ ]]; then
    command brew bundle dump --global --force --no-vscode
  fi
}

# ghq: gf + Enter でリポジトリを fzf 絞り込み → cd
gf() {
  local selected_dir
  selected_dir=$(ghq list | fzf --prompt="ghq> " --height=50% --reverse) || return
  [ -n "$selected_dir" ] && cd "$(ghq root)/$selected_dir"
}
