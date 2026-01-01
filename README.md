# tressa

Personal dotfiles repository.

## Setup

```bash
make symbolic_links
```

This creates symbolic links from `dotfiles/` to your home directory. Existing files are backed up to `~/.dotbackup`.

## Structure

```
dotfiles/    # Configuration files to be symlinked
.bin/        # Setup scripts
```

## Brewfile

The `brew` function in `.zshrc` automatically runs `brew bundle dump --global --force` after `brew install/uninstall/tap/untap`, keeping `~/.Brewfile` up to date.
