#!/bin/bash
# AI agent setup (Claude Code, Codex, etc.): prerequisites and configuration links.
set -e
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

brew_ensure jq jq
brew_ensure claude --cask claude-code
brew_ensure codex --cask codex

log "Linking AI agent configuration..."
ensure_dir "$HOME/.agents"
ensure_dir "$HOME/.agents/skills"
ensure_dir "$HOME/.agents/agents"
ensure_dir "$HOME/.agents/plans"
ensure_dir "$HOME/.claude"
ensure_dir "$HOME/.claude/skills"
ensure_dir "$HOME/.claude/agents"
ensure_dir "$HOME/.codex"
ensure_dir "$HOME/.codex/agents"
ln -sf "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.agents/AGENTS.md"
ln -sf "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.claude/CLAUDE.md"
ln -sf "$DOTFILES_DIR/agents/AGENTS.md" "$HOME/.codex/AGENTS.md"
ln -sfn "$DOTFILES_DIR/agents/hooks" "$HOME/.agents/hooks"
ln -sf "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
ln -sfn "$DOTFILES_DIR/codex/rules" "$HOME/.codex/rules"
ln -sf "$DOTFILES_DIR/codex/hooks.json" "$HOME/.codex/hooks.json"
# Remove only legacy links previously created by this repository. Skills now
# replace Claude commands and deprecated Codex prompts.
if [ -L "$HOME/.claude/commands" ] && [ "$(readlink "$HOME/.claude/commands")" = "$DOTFILES_DIR/claude/commands" ]; then
    unlink "$HOME/.claude/commands"
fi
if [ -L "$HOME/.codex/prompts" ] && [ "$(readlink "$HOME/.codex/prompts")" = "$DOTFILES_DIR/codex/prompts" ]; then
    unlink "$HOME/.codex/prompts"
fi
if [ -L "$HOME/.claude/hooks" ] && [ "$(readlink "$HOME/.claude/hooks")" = "$DOTFILES_DIR/claude/hooks" ]; then
    unlink "$HOME/.claude/hooks"
fi
# Symlink each skill individually so external tools can add skills alongside
for skill_dir in "$DOTFILES_DIR/agents/skills"/*/; do
    skill_name=$(basename "$skill_dir")
    ln -sfn "$skill_dir" "$HOME/.agents/skills/$skill_name"
    ln -sfn "$skill_dir" "$HOME/.claude/skills/$skill_name"
done
# Symlink each agent individually so external tools can add agents alongside
for agent_file in "$DOTFILES_DIR/agents/agents"/*.md; do
    [ -f "$agent_file" ] || continue
    agent_name=$(basename "$agent_file")
    ln -sf "$agent_file" "$HOME/.agents/agents/$agent_name"
    ln -sf "$agent_file" "$HOME/.claude/agents/$agent_name"
done
# Codex custom agents use TOML configuration rather than Claude's Markdown
# frontmatter, so install the small client-specific adapters separately.
for agent_file in "$DOTFILES_DIR/codex/agents"/*.toml; do
    [ -f "$agent_file" ] || continue
    agent_name=$(basename "$agent_file")
    ln -sf "$agent_file" "$HOME/.codex/agents/$agent_name"
done

log "AI agent setup complete."
echo "    Launch Claude Code and Codex to complete first-run authentication."
