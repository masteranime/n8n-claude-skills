# Contributing to n8n-claude-skills

Got a battle-tested n8n pattern? PRs welcome.

## What makes a good skill

A skill belongs here if it encodes **production knowledge** that LLMs currently get wrong. Three tests:

1. **Would Claude hallucinate without this?** If Claude already handles the task well, no skill needed.
2. **Is it from real production use?** Toy patterns don't survive real data. We want skills distilled from workflows that shipped to customers.
3. **Is it reusable?** One-off client logic doesn't belong. Generalize or don't submit.

## Skill format

Each skill is a folder under `skills/`:

```
your-skill-name/
├── SKILL.md           # required
└── references/        # optional supporting docs or example JSON
    └── ...
```

### SKILL.md structure

```markdown
---
name: your-skill-name
description: When to use this skill. Include BOTH what it does AND the user phrases/contexts that should trigger it. Be specific — vague descriptions don't trigger reliably. Err on the pushy side: "Use this skill whenever the user mentions X, Y, or Z, even if they don't explicitly ask for it."
---

# Human-Readable Title

Short explainer: what problem this solves, why it matters.

## Core principles / When to use

Bullet the rules. These are what Claude actually follows at generation time.

## The pattern / process

Step by step. Show the happy path first, then edge cases.

## Anti-patterns

What NOT to do and why. This is often the most valuable section.

## Reference files (if any)

Point to `references/*.md` or JSON templates in your skill folder.
```

### Description field — the trigger

The `description` frontmatter is what makes Claude decide to use the skill. Rules:

- Start with what the skill does (one sentence).
- List trigger phrases and contexts explicitly.
- Keep under 500 characters.
- Be "pushy" — Claude under-triggers by default.

Good example (from `enrichment-waterfall`):
> "Build multi-vendor data enrichment waterfalls in n8n — cascading API calls across SerpAPI, Hunter.io, Apollo, Clearbit, LLM extractors, and scrapers with cost-aware fallbacks. Use this skill whenever the user wants to enrich leads…"

Bad example:
> "Helps with lead enrichment in n8n."

## PR checklist

- [ ] Folder name is `kebab-case` and matches the `name:` field
- [ ] Description lists trigger phrases
- [ ] Skill body is under 500 lines (use references/ for more)
- [ ] Anti-patterns section included
- [ ] Tested with Claude Code on at least one real prompt
- [ ] README updated if it's a new top-level skill

## Review criteria

Maintainers look for:

1. Is the pattern actually production-shaped? (error handling, idempotency, observability)
2. Does the skill improve Claude's output vs. no-skill baseline?
3. Is the trigger description specific enough to not over-fire?

Expect review within a week. Don't ghost your PR — responsive contributors get merged.
