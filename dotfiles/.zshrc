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

# ghq: gf + Enter でリポジトリ（+ Claude Code ワークツリー）を fzf 絞り込み → cd
gf() {
  local root selected_dir
  root=$(ghq root)
  selected_dir=$(
    ghq list -p | while IFS= read -r repo; do
      echo "${repo#"$root"/}"
      # Claude Code ネイティブワークツリー（.claude/worktrees/<name>）も候補に含める
      for wt in "$repo"/.claude/worktrees/*(/N); do
        echo "${wt#"$root"/}"
      done
    done | fzf --prompt="ghq> " --height=50% --reverse
  ) || return
  [ -n "$selected_dir" ] && cd "$root/$selected_dir" || return
}
