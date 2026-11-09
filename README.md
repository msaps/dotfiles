# Dotfiles

Personal macOS dotfiles used for two jobs:

1. Keep everyday shell and tool configuration under version control.
2. Bootstrap a fresh machine by installing packages and wiring the managed files into `$HOME`.

The repository is intentionally simple. Most folders mirror a target location in the home directory. Setup is split into `make terminal`, `make agents` and `make apps`, so each machine only runs what it needs.

## Quick Start

Clone the repo into `~/.dotfiles` and run the targets you need:

```bash
git clone https://github.com/msaps/Dotfiles.git ~/.dotfiles
cd ~/.dotfiles
make help
```

| Target | Does |
| --- | --- |
| `make terminal` | CLI tools, Oh My Zsh, and shell/git/tmux/gh config |
| `make agents` | AI agent prerequisites and config (Claude Code, Codex) |
| `make apps` | Homebrew apps, fonts, and macOS defaults |
| `make all` | Everything above |

Targets combine (`make terminal agents`) and are idempotent: anything already installed is skipped and the symlinks are simply refreshed. On a machine where Homebrew is read-only, package installs are skipped and linking still happens.

## What This Repo Manages

- Shell startup files for `zsh`
- Global Git config and ignore rules
- Homebrew environment and package list
- GitHub CLI config
- Shared Claude Code and Codex skills, instructions, and specialist agents
- iTerm fonts and profile export
- A few machine-level helper files such as `.curlrc`

## Project Guide

The main project documentation lives in [`docs/project-guide.md`](~/.dotfiles/docs/project-guide.md). It covers:

- the folder layout
- the symlink map
- the installer flow
- bootstrap assumptions
- how to update the repo safely

## Manual Steps After Install

Some tools still require interactive setup after the script finishes:

1. Restart the shell or run `exec zsh`.
2. Import [`iterm/iterm-profiles.json`](~/.dotfiles/iterm/iterm-profiles.json) into iTerm2 if you want the saved profile.
3. Run `gh auth login`.
4. Launch Claude Code and Codex and complete any first-run authentication.

Codex user configuration remains local at `~/.codex/config.toml` and is not
managed by this repository. Durable command policy lives in `codex/rules/`,
custom agent definitions in `codex/agents/`, and shared workflows in
`agents/skills/`.

## Updating

Pull the latest changes and rerun the targets you use:

```bash
cd ~/.dotfiles
git pull --rebase
make terminal agents
```
