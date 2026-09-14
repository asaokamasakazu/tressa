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

# git: gb + Enter でローカルブランチを fzf 絞り込み → switch（現在のブランチを先頭、以降アルファベット順）
gb() {
  local current selected_branch
  current=$(git branch --show-current)
  selected_branch=$(
    {
      [ -n "$current" ] && echo "$current"
      git branch --sort=refname --format='%(refname:short)' | grep -vxF -- "$current"
    } | fzf --prompt="branch> " --height=50% --reverse
  ) || return
  [ -n "$selected_branch" ] && git switch "$selected_branch"
}

# git: gbd + Enter でローカルブランチを fzf 複数選択（Tab）→ 削除（未マージは確認して -D）
# shellcheck disable=SC2296,SC2162 # zsh 固有構文（${(f)var} / read -q）のため
gbd() {
  local current selected b err
  current=$(git branch --show-current)
  selected=$(
    git branch --sort=refname --format='%(refname:short) %(upstream:track)' \
      | awk -v cur="$current" '$1 != cur' \
      | fzf -m --prompt="delete> " --height=50% --reverse --header="Tab で複数選択" \
      | awk '{print $1}'
  ) || return
  [ -n "$selected" ] || return
  for b in ${(f)selected}; do
    if err=$(git branch -d "$b" 2>&1); then
      echo "$err"
    elif [[ "$err" == *"not fully merged"* ]]; then
      printf "%s は未マージです。強制削除 (-D) しますか？ [y/N] " "$b"
      if read -q; then echo; git branch -D "$b"; else echo; fi
    else
      echo "$err"
    fi
  done
}

# gcloud の認証が切れていたら自動で再ログイン
gcloud() {
  if [[ "$1" != "auth" ]] && ! command gcloud auth print-access-token >/dev/null 2>&1; then
    echo "gcloud session expired. Re-authenticating..." >&2
    command gcloud auth login --update-adc || return $?
  fi
  command gcloud "$@"
}
