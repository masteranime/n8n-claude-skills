# n8n-claude-skills

> Production-grade [Claude Skills](https://www.anthropic.com/news/agent-skills) for building, debugging, and shipping n8n workflows — distilled from **100+ production workflows** by an [n8n Verified Creator](https://n8n.io/creators/shaheer03).

Give Claude Code the instincts of a senior n8n engineer. No more hallucinated node types, broken expressions, or toy demos.

```bash
# 60-second install
npx n8n-claude-skills install
```

Then in Claude Code:

> *"Build me an n8n workflow that ingests leads from a webhook, enriches them via SerpAPI → Apollo waterfall, scores spam with a composite check, and writes qualified leads to Google Sheets."*

Claude now builds a **real, production-shaped workflow** — correct node types, proper expressions, checkpoint tables, error branches, and retry logic. Not a Figma mockup of a workflow. A workflow.

---

## What's in the box

| Skill | What it does | When it fires |
|---|---|---|
| **`workflow-architect`** | Designs n8n workflows from requirements. Picks the right nodes, structures branches, and wires error paths. | "build a workflow that…", "design an automation for…" |
| **`chain-llm-pattern`** | The Groq/OpenAI `chain_llm` pattern for multi-step LLM reasoning (entity extraction → categorization → scoring). | "extract structured data with LLMs", "multi-step prompt chain" |
| **`enrichment-waterfall`** | Multi-vendor enrichment waterfalls (SerpAPI → Hunter → Apollo → LLM fallback) with cost-aware fallbacks. | "lead enrichment", "data waterfall", "Clay alternative" |
| **`mysql-checkpointing`** | Production MySQL patterns: batch processing, duplicate prevention, resumable pipelines, dynamic table creation. | "idempotent pipeline", "checkpoint table", "batch processing" |
| **`debug-workflow`** | Systematic n8n debugging: expression syntax, pinned data, sub-workflow isolation, execution log reading. | "why is my workflow failing", "debug this n8n error" |

More shipping weekly. PRs welcome.

---

## Why this exists

LLMs confidently hallucinate n8n. They invent node types (`Googlesheets` instead of `Google Sheets`), mix up expression syntax (`{{$json["x"]}}` vs `={{ $json.x }}`), forget about sub-workflows, and ship demos that collapse the moment you plug in real data.

This pack teaches Claude the patterns that actually survive production — the ones we use in:

- Real estate financial reporting (Google Sheets → Claude API → PDF → Gmail)
- Multi-language call transcript pipelines (EN/ES/PT, Groq chain_llm)
- Composite spam scoring with Twilio retry logic
- 47-node batch processing with duplicate prevention
- WhatsApp commerce agents with Stripe + Meta Cloud API

You get the instincts, not the code.

---

## Install

### Claude Code (recommended)

```bash
# Clone and install to your user skills directory
git clone https://github.com/masteranime/n8n-claude-skills.git
cd n8n-claude-skills
./install.sh
```

Claude Code picks up the skills automatically.

### Manual (any Skills-compatible agent)

Copy any folder inside `skills/` into your agent's skills directory. Each folder is a self-contained skill with a `SKILL.md` and optional reference files.

Works with: Claude Code, Cursor, Codex, Gemini CLI, Opencode, and anything following the [Agent Skills spec](https://github.com/github/agent-skills).

---

## Quick demo

**Prompt:**
> Build an n8n workflow that receives Stripe `checkout.session.completed` webhooks, looks up the customer in our MySQL orders table, sends a WhatsApp confirmation via Meta Cloud API, and retries via Twilio SMS if WhatsApp fails.

**Without this pack:** Claude writes pseudocode, invents `Whatsapp Node`, forgets the retry branch, skips the idempotency check.

**With this pack:** Claude produces a 14-node workflow JSON you can paste into n8n — with webhook signature verification, a MySQL `processed_webhooks` checkpoint, proper Meta Cloud API `messages` endpoint, an `IF` branch on WhatsApp failure feeding into Twilio with exponential backoff, and an error trigger sub-workflow.

Full example: [`examples/stripe-whatsapp-fallback.json`](./examples/stripe-whatsapp-fallback.json)

---

## Who built this

[Muhammad Shaheer](https://linkedin.com/in/muhammad-shaheer-898513192) — n8n Verified Creator ([100+ workflows](https://n8n.io/creators/shaheer03)), Claude Code daily user, 4+ years shipping production AI automation.

These skills are extracted from real client work — real estate finance pipelines, multi-language NLP, voice lead automation, lead enrichment waterfalls. If a pattern is in here, it shipped to a paying customer first.

---

## Contributing

Have a battle-tested n8n pattern? Open a PR. See [CONTRIBUTING.md](./CONTRIBUTING.md) for the skill format and review criteria.

Good additions:
- Domain skills (e-commerce flows, real estate, healthcare)
- Integration skills (specific SaaS tools)
- Debug recipes for common footguns

## License

MIT. Use it, fork it, ship it. Credit appreciated but not required.

---

**⭐ Star the repo if this saved you an hour of debugging n8n expressions.**
