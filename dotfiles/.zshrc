# Alias
alias ecommit='git commit --allow-empty -m "empty commit"'
alias bucc='brew upgrade claude-code'

# Local bin: User scripts
export PATH="$HOME/.local/bin:$PATH"

# Kiro: Shell integration
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Antigravity: CLI tools
export PATH="/Users/masakazuasaoka/.antigravity/antigravity/bin:$PATH"

# Homebrew: Auto-update Brewfile after install/uninstall/tap/untap
brew() {
  command brew "$@"
  if [[ "$1" =~ ^(install|uninstall|tap|untap)$ ]]; then
    command brew bundle dump --global --force --no-vscode
  fi
}
