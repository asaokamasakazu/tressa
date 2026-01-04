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
  local dotdir="${script_dir}/../dotfiles"

  for f in "$dotdir"/.??*; do
    local filename
    filename=$(basename "$f")
    local target="$HOME/$filename"

    if [[ -e "$target" ]]; then
      command mv "$target" "$HOME/.dotbackup"
    fi
    command ln -snf "$f" "$target"
    command echo "Linked: $filename"
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
