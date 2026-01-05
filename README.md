# tressa

Personal dotfiles repository for macOS.

## Setup

```bash
make symbolic_links
```

This creates symbolic links from `dotfiles/` to your home directory. Existing files are backed up to `~/.dotbackup`.

## Structure

```
dotfiles/           # Configuration files to be symlinked
  .Brewfile         # Homebrew packages
  .claude/          # Claude Code settings
  .gitconfig        # Git configuration
  .gitignore_global
  .warp/            # Warp terminal settings
  .zprofile         # Zsh login profile
  .zshrc            # Zsh configuration
.bin/               # Setup scripts
.github/workflows/  # CI workflows
```

## Brewfile

The `brew` function in `.zshrc` automatically runs `brew bundle dump --global --force --no-vscode` after `brew install/uninstall/tap/untap`, keeping `~/.Brewfile` up to date.

## CI

GitHub Actions runs on every push:
- **Lint**: shellcheck for shell scripts
- **Symlink Test**: Verify symlink creation
- **Brewfile Check**: Validate Brewfile syntax
- **YAML Validation**: Validate YAML files
