# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a dotfiles repository (tressa) for managing personal configuration files across machines.

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
├── dotfiles/          # Dotfiles to be symlinked to ~/
│   └── .??*           # Files matching this pattern are linked
├── .bin/
│   └── symbolic_links.sh  # Symlink creation script
└── Makefile           # make symbolic_links
```

The `symbolic_links.sh` script:
- Creates `~/.dotbackup` for backing up existing files
- Symlinks all `dotfiles/.??*` files to `$HOME`
- Existing files are moved to `~/.dotbackup` before linking
