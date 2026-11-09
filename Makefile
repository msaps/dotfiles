SCRIPTS := $(dir $(lastword $(MAKEFILE_LIST)))scripts

.DEFAULT_GOAL := help
.PHONY: help terminal agents apps all

help: ## Show available targets
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F':.*## ' '{printf "  make %-10s %s\n", $$1, $$2}'

terminal: ## CLI tools, Oh My Zsh, and shell/git/tmux/gh config
	@bash "$(SCRIPTS)/terminal.sh"

agents: ## AI agent prerequisites and config (Claude Code, Codex)
	@bash "$(SCRIPTS)/agents.sh"

apps: ## Homebrew apps, fonts, and macOS defaults
	@bash "$(SCRIPTS)/apps.sh"

all: terminal agents apps ## Everything
