# Project Guide

## Purpose

This repository is a home-directory bootstrap for a macOS development machine.

It does not use a dotfile manager. Instead, it keeps a small set of config files in normal folders and provides separate `terminal`, `agents` and `apps` entrypoints to:

1. install prerequisite tooling
2. install packages and applications
3. symlink managed files into `$HOME`
4. install local fonts

The result is a repo that is easy to inspect and easy to rerun on an existing machine.

## Layout

The top-level directories are organized by target tool rather than by automation step.

| Path | Purpose |
| --- | --- |
| [`Makefile`](/Users/msaps/.dotfiles/Makefile) | Public `terminal`, `agents`, `apps`, `all` entrypoints |
| [`scripts/`](/Users/msaps/.dotfiles/scripts) | One idempotent script per target, plus shared `lib.sh` helpers |
| [`Brewfile.cli`](/Users/msaps/.dotfiles/Brewfile.cli) | CLI formulae for `make terminal` |
| [`Brewfile.apps`](/Users/msaps/.dotfiles/Brewfile.apps) | Development tools and casks for `make apps` |
| [`Gemfile`](/Users/msaps/.dotfiles/Gemfile) | Ruby gem dependency manifest |
| [`zsh/`](/Users/msaps/.dotfiles/zsh) | Shell startup files |
| [`git/`](/Users/msaps/.dotfiles/git) | Global Git config and ignore rules |
| [`homebrew/`](/Users/msaps/.dotfiles/homebrew) | Homebrew environment file |
| [`gh/`](/Users/msaps/.dotfiles/gh) | GitHub CLI config |
| [`claude/`](/Users/msaps/.dotfiles/claude) | Claude Code settings and hooks |
| [`codex/`](/Users/msaps/.dotfiles/codex) | Codex execution rules and custom-agent adapters |
| [`agents/`](/Users/msaps/.dotfiles/agents) | Shared instructions, skills, and specialist-agent prompts |
| [`misc/`](/Users/msaps/.dotfiles/misc) | Small standalone dotfiles such as `.curlrc` |
| [`iterm/`](/Users/msaps/.dotfiles/iterm) | Fonts plus exported iTerm profile |

## Bootstrap Flow

Each Make target runs one script in [`scripts/`](/Users/msaps/.dotfiles/scripts). Every script is idempotent: it installs only what is missing, then refreshes its symlinks, so the same command is used for first-time setup and for updating. Homebrew (and Xcode Command Line Tools) are installed on demand by whichever target first needs them.

| Target | Script | Does |
| --- | --- | --- |
| `make terminal` | [`terminal.sh`](/Users/msaps/.dotfiles/scripts/terminal.sh) | `Brewfile.cli`, Oh My Zsh, `zsh-autosuggestions`, links for zsh/git/curl/tmux/brew/gh |
| `make agents` | [`agents.sh`](/Users/msaps/.dotfiles/scripts/agents.sh) | Installs `jq` and Claude Code if their commands are missing, and the ChatGPT app (Codex) if its app bundle is missing, then links `~/.agents`, `~/.claude`, `~/.codex` |
| `make apps` | [`apps.sh`](/Users/msaps/.dotfiles/scripts/apps.sh) | macOS Finder defaults, tap trust, `Brewfile.apps`, iTerm fonts |
| `make all` | | `terminal`, `agents`, then `apps` |

When Homebrew's Cellar is not writable (for example a managed work machine), package installs are logged as skipped and linking still runs. Targets can be combined, e.g. `make terminal agents`.

## Symlink Map

The repo uses explicit symlinks rather than a generated map. This is the current behavior of [`terminal.sh`](/Users/msaps/.dotfiles/scripts/terminal.sh) and [`agents.sh`](/Users/msaps/.dotfiles/scripts/agents.sh):

| Repo file | Linked location |
| --- | --- |
| [`zsh/.zshrc`](/Users/msaps/.dotfiles/zsh/.zshrc) | `~/.zshrc` |
| [`zsh/.zshenv`](/Users/msaps/.dotfiles/zsh/.zshenv) | `~/.zshenv` |
| [`zsh/.profile`](/Users/msaps/.dotfiles/zsh/.profile) | `~/.profile` |
| [`git/.gitconfig`](/Users/msaps/.dotfiles/git/.gitconfig) | `~/.gitconfig` |
| [`git/.gitignore`](/Users/msaps/.dotfiles/git/.gitignore) | `~/.gitignore` |
| [`misc/.curlrc`](/Users/msaps/.dotfiles/misc/.curlrc) | `~/.curlrc` |
| [`agents/AGENTS.md`](/Users/msaps/.dotfiles/agents/AGENTS.md) | `~/.agents/AGENTS.md` |
| [`agents/hooks`](/Users/msaps/.dotfiles/agents/hooks) | `~/.agents/hooks` |
| [`agents/AGENTS.md`](/Users/msaps/.dotfiles/agents/AGENTS.md) | `~/.claude/CLAUDE.md` |
| [`claude/settings.json`](/Users/msaps/.dotfiles/claude/settings.json) | `~/.claude/settings.json` |
| [`agents/AGENTS.md`](/Users/msaps/.dotfiles/agents/AGENTS.md) | `~/.codex/AGENTS.md` |
| Each directory in [`agents/skills`](/Users/msaps/.dotfiles/agents/skills) | `~/.agents/skills/<name>` and `~/.claude/skills/<name>` |
| Each file in [`agents/agents`](/Users/msaps/.dotfiles/agents/agents) | `~/.agents/agents/<name>.md` and `~/.claude/agents/<name>.md` |
| Each file in [`codex/agents`](/Users/msaps/.dotfiles/codex/agents) | `~/.codex/agents/<name>.toml` |
| [`codex/hooks.json`](/Users/msaps/.dotfiles/codex/hooks.json) | `~/.codex/hooks.json` |
| [`codex/rules`](/Users/msaps/.dotfiles/codex/rules) | `~/.codex/rules` |
| [`gh/config.yml`](/Users/msaps/.dotfiles/gh/config.yml) | `~/.config/gh/config.yml` |

## What Each Area Configures

### Shell

[`zsh/.zshrc`](/Users/msaps/.dotfiles/zsh/.zshrc) sets up:

- Oh My Zsh with the `agnoster` theme
- plugins for `git`, `z`, `xcode`, `macos`, and `zsh-autosuggestions`
- Homebrew shell environment
- `rbenv`
- Volta paths
- a few local aliases for `code`, Tower, and Xcode DerivedData cleanup

[`zsh/.zshenv`](/Users/msaps/.dotfiles/zsh/.zshenv) and [`zsh/.profile`](/Users/msaps/.dotfiles/zsh/.profile) currently just make Volta available in login and non-login shells.

### Development Tooling

The Brewfiles are the package inventory, split by target: `Brewfile.cli` (terminal) and `Brewfile.apps` (apps). Between them they install:

- CLI tools like `git`, `gh`, `curl`, `aria2`, and `cloc`
- development tools like `go`, `rbenv`, `volta`, `swiftlint`, `vapor`, and `xcodes`
- desktop apps including iTerm2, VS Code, Tower, Proxyman, Claude, and a few utility apps

[`Gemfile`](/Users/msaps/.dotfiles/Gemfile) is intentionally small. Ruby version selection and `bundle install` remain manual steps; the bootstrap installs `rbenv` but does not configure a Ruby version.

### Git and GitHub

[`git/.gitconfig`](/Users/msaps/.dotfiles/git/.gitconfig) keeps the global user identity, default branch, and a shared global ignore file.

[`gh/config.yml`](/Users/msaps/.dotfiles/gh/config.yml) stores GitHub CLI behavior such as aliases and prompt preferences.

### AI Tooling

[`agents/AGENTS.md`](/Users/msaps/.dotfiles/agents/AGENTS.md) is shared between Claude Code and Codex so both tools inherit the same local working rules. Reusable workflows use the open `SKILL.md` format and are linked into both clients' user skill directories.

[`claude/settings.json`](/Users/msaps/.dotfiles/claude/settings.json) manages Claude permissions and enabled plugins. Claude and Codex both run the shared Git push hook in [`agents/hooks`](/Users/msaps/.dotfiles/agents/hooks), which blocks bare force pushes and permits `--force-with-lease` on any branch except `main`/`master`.

Codex user configuration remains isolated in `~/.codex/config.toml` and is not managed by this repository. This allows Codex to persist preferences, project trust, hook approvals, and UI state independently on each machine.

[`codex/hooks.json`](/Users/msaps/.dotfiles/codex/hooks.json) also runs the shared [`git-session-sync.sh`](/Users/msaps/.dotfiles/agents/hooks/git-session-sync.sh) on session startup, resume, and clear, but not compaction. It uses the session's working directory, including nested directories and linked worktrees; it does not sync `~/.dotfiles` unless that is the active repository.

The sync fetches all configured remotes and prunes deleted remote branches, then fast-forwards only the current branch to its configured remote upstream when the checkout is clean. Local changes (including untracked files and dirty submodules), local commits, detached HEAD, missing upstreams, and in-progress Git operations prevent automatic fast-forwarding. It never stashes, rebases, resets, switches branches, or pushes. Fast-forwarding also refuses to overwrite ignored files, disables Git merge hooks, and leaves submodule checkouts alone.

The script uses Bash, Git, and `jq`, like the existing push hook. Codex allows it 30 seconds and receives a short result as agent context. Fetch failures leave the checked-out branch unchanged and do not block the session. Non-Git directories are ignored. The shared instructions tell Claude and other agents to use the same script before new implementation work when no session hook has run:

```sh
"$HOME/.agents/hooks/git-session-sync.sh" --cwd "$PWD"
```

Run `make agents` to install the managed hook files. In Codex, review and trust the new hook through `/hooks` before its first run; hook trust stays in local configuration and is not bootstrapped or committed. See the [official hook documentation](https://learn.chatgpt.com/docs/hooks). Run `bash tests/git-session-sync.sh` to exercise sync behavior against temporary local repositories.

[`codex/rules/default.rules`](/Users/msaps/.dotfiles/codex/rules/default.rules) manages durable Codex command approvals and denials, aligned with the intent of Claude's permission lists where the clients expose equivalent controls.

## Assumptions and Constraints

This repo currently assumes:

- macOS
- a user account with a writable home directory
- internet access during bootstrap
- Homebrew installed to `/opt/homebrew`
- the repo living at `~/.dotfiles`

Those assumptions are fine for a personal machine bootstrap, but they are worth remembering before trying to generalize the setup.

## How To Extend It

When adding a new managed config:

1. Store the source file in a tool-specific folder in the repo.
2. Add the corresponding symlink step to the matching script in [`scripts/`](/Users/msaps/.dotfiles/scripts) (`terminal.sh` or `agents.sh`).
3. If the tool needs installation, add it to `Brewfile.cli` or `Brewfile.apps` (or a `brew_ensure` call for agent prerequisites), or document the manual step.
4. Update this guide if the bootstrap flow or symlink map changes.

Keeping those three pieces in sync is the main maintenance rule for this project.
