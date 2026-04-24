#!/usr/bin/env bash
# n8n-claude-skills installer
# Copies all skills to your Claude Code user skills directory.

set -e

# Determine skills directory
# Claude Code user skills live in ~/.claude/skills (Linux/Mac) or %USERPROFILE%\.claude\skills (Windows)
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"

echo "📦 Installing n8n-claude-skills to $SKILLS_DIR"

mkdir -p "$SKILLS_DIR"

# Copy each skill folder
for skill in skills/*/; do
  skill_name=$(basename "$skill")
  echo "  → $skill_name"
  cp -r "$skill" "$SKILLS_DIR/"
done

echo ""
echo "✅ Installed $(ls -d skills/*/ | wc -l) skills."
echo ""
echo "Restart Claude Code (or reload) and try:"
echo "  \"Build me an n8n workflow that ingests Stripe webhooks and sends WhatsApp confirmations.\""
echo ""
echo "Star the repo if this saved you time: https://github.com/masteranime/n8n-claude-skills"
