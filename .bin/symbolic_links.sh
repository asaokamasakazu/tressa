#!/usr/bin/env bash
set -ue

helpmsg() {
  command echo "Usage: $0 [--help | -h] [--debug | -d]" 0>&2
  command echo ""
  command echo "Options:"
  command echo "  -h, --help   Show this help message"
  command echo "  -d, --debug  Enable debug mode"
}

link_to_homedir() {
  command echo "Backup old dotfiles..."
  if [ ! -d "$HOME/.dotbackup" ]; then
    command echo "$HOME/.dotbackup not found. Auto Make it"
    command mkdir "$HOME/.dotbackup"
  fi

  local script_dir
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
  local dotdir
  dotdir="$(cd "$script_dir/../dotfiles" && pwd -P)"

  find "$dotdir" -type f | while read -r f; do
    local relpath="${f#"$dotdir"/}"
    local target="$HOME/$relpath"
    local target_dir
    target_dir=$(dirname "$target")

    # 親ディレクトリがシンボリックリンクの場合は削除してから実ディレクトリを作成（循環参照を避けるため）
    if [[ -L "$target_dir" ]]; then
      command rm "$target_dir"
    fi
    if [[ ! -d "$target_dir" ]]; then
      command mkdir -p "$target_dir"
    fi

    if [[ -e "$target" && ! -L "$target" ]]; then
      local backup_dir
      backup_dir="$HOME/.dotbackup/$(dirname "$relpath")"
      command mkdir -p "$backup_dir"
      command mv "$target" "$backup_dir/"
    fi

    command ln -snf "$f" "$target"
    command echo "Linked: $relpath"
  done
}

while [ $# -gt 0 ]; do
  case ${1} in
    --debug|-d)
      set -uex
      ;;
    --help|-h)
      helpmsg
      exit 0
      ;;
  esac
  shift
done

link_to_homedir
printf "\033[1;32mDone: Symbolic links created successfully.\033[0m\n"
