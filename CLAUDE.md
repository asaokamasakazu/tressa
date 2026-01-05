# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository (tressa) for managing personal configuration files on macOS.

## Commands

```bash
# Create symbolic links from dotfiles/ to home directory
make symbolic_links

# Or run directly with options
./.bin/symbolic_links.sh --help    # Show help
./.bin/symbolic_links.sh --debug   # Run with debug output
```

## Architecture

```
tressa/
├── dotfiles/              # Dotfiles to be symlinked to ~/
│   ├── .Brewfile          # Homebrew packages
│   ├── .claude/           # Claude Code settings
│   │   ├── CLAUDE.md
│   │   ├── settings.json
│   │   └── skills/
│   ├── .gitconfig         # Git configuration
│   ├── .gitignore_global  # Global gitignore
│   ├── .warp/             # Warp terminal settings
│   ├── .zprofile          # Zsh login profile
│   ├── .zshenv            # Zsh environment variables
│   └── .zshrc             # Zsh configuration
├── .bin/
│   └── symbolic_links.sh  # Symlink creation script
├── .github/workflows/
│   └── lint-and-test.yaml # CI workflow
└── Makefile               # make symbolic_links
```

The `symbolic_links.sh` script:
- Recursively creates file-level symlinks (not directory-level)
- Creates `~/.dotbackup` for backing up existing files
- Merges with existing directories (does not overwrite)
- Existing files are moved to `~/.dotbackup` before linking

## Brewfile

The `brew` function in `dotfiles/.zshrc` automatically runs `brew bundle dump --global --force --no-vscode` after `brew install/uninstall/tap/untap`.

## CI

GitHub Actions (`lint-and-test.yaml`):
- Lint shell scripts with shellcheck
- Test symlink creation
- Validate Brewfile syntax
- Validate YAML files
