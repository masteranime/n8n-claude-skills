# n8n Node Catalog (Battle-Tested)

Curated list of nodes that survive production. Use these by name — they are the exact n8n type strings.

## Triggers

| Use case | Node | Notes |
|---|---|---|
| External webhook | `Webhook` | Set `responseMode: "responseNode"` if processing takes >3s. Use `Respond to Webhook` to reply early. |
| Recurring jobs | `Schedule Trigger` | Cron syntax. Prefer hourly+ over per-minute. For per-minute, check if a webhook exists from the source. |
| Conversational | `Chat Trigger` | Pairs with `AI Agent` for chat UIs. |
| Form intake | `Form Trigger` | Built-in form, hosted by n8n. Skips needing a frontend. |
| Manual / dev | `Manual Trigger` | Testing only. Never ship workflows that depend on it. |
| Called by parent | `Execute Workflow Trigger` | For sub-workflows. Defines the input schema. |

## Logic / control flow

| Use case | Node | Notes |
|---|---|---|
| Branch on condition | `IF` | Two outputs: true / false. Always wire both. |
| Multi-way switch | `Switch` | More than 2 branches. Up to 4 output cases by default, configurable. |
| Merge branches | `Merge` | Modes: append, multiplex, combineByPosition, combineByMatchingFields. Pick deliberately. |
| Loop over batches | `Split In Batches` | `batchSize` per chunk; `done` output fires when complete. |
| Loop a fixed N | Use `Code` to emit N items | n8n has no native "for i in range" — generate items in `Code`. |
| Wait / delay | `Wait` | For backoff, polling, or human-in-the-loop. |
| Error handler | `Error Trigger` | Lives in a separate workflow. Catches uncaught errors from any workflow that names it. |

## Data transformation

| Use case | Node | Notes |
|---|---|---|
| Set/edit fields | `Set` | Replaces/adds named fields. Use over `Code` when transformation is simple. |
| Custom JS / TS | `Code` | Runs JavaScript or Python. Use sparingly — every `Code` node is harder to read than a purpose-built one. |
| Array operations | `Item Lists` | Split out items, aggregate, sort, remove duplicates, summarize. |
| Date math | `Date & Time` | Add/subtract durations, format. |
| HTTP request (generic API) | `HTTP Request` | Set `continueOnFail: true` for vendor calls. Use n8n credential, never inline auth. |
| HTML parsing | `HTML` | Extract via CSS selectors. |
| Markdown ↔ HTML | `Markdown` | Both directions. |
| File operations | `Read/Write Files from Disk` | Self-hosted only. |

## LLM / AI nodes (LangChain integration)

Use these instead of raw `HTTP Request` to LLM APIs. They handle retries, schema validation, and token accounting.

| Use case | Node | Notes |
|---|---|---|
| Conversational agent with tools | `AI Agent` | The default for tool-using agents. |
| Single-prompt LLM call | `Basic LLM Chain` | Plain prompt → response. |
| Structured output extraction | `Information Extractor` | Bind output to a JSON schema. Best for entity extraction. |
| Classification | `Text Classifier` | Predefined labels with reasoning. |
| Sentiment | `Sentiment Analysis` | Simpler than `Text Classifier` for basic cases. |
| Summarization | `Summarization Chain` | Map-reduce over long docs. |
| RAG / retrieval | `Question and Answer Chain` | Retriever + LLM. |
| Embeddings | `Embeddings OpenAI` / `Embeddings Cohere` / `Embeddings HuggingFace` | Choose based on vector store and language coverage. |
| Vector store | `Vector Store In-Memory` / `Vector Store Pinecone` / `Vector Store Supabase` / `Vector Store Qdrant` | Pick based on volume + persistence. In-memory for dev only. |
| LLM provider models | `OpenAI Chat Model` / `Anthropic Chat Model` / `Groq Chat Model` / `Ollama Chat Model` | Sub-nodes plugged into the chains above. |

## Storage

| Use case | Node | Notes |
|---|---|---|
| Relational DB | `MySQL` / `Postgres` | Use credentials. Set `connectionLimit: 5` to avoid pool exhaustion. |
| Sheets | `Google Sheets` | Strict on capitalization. Avoid for >10k rows — use a real DB. |
| Document DB | `MongoDB` | Filter syntax follows MongoDB query operators. |
| Object storage | `AWS S3` / `Google Cloud Storage` / `MinIO` | For files, large blobs, exports. |
| Key-value | `Redis` | Cache, locks, rate limits. |

## Communication

| Use case | Node | Notes |
|---|---|---|
| Email | `Gmail` / `Microsoft Outlook` / `Send Email` (SMTP) | Gmail/Outlook use OAuth; SMTP needs credentials. |
| WhatsApp (official) | `WhatsApp Business Cloud` | Meta Cloud API. Templates must be pre-approved in Meta Business Manager. |
| WhatsApp (community) | Custom `HTTP Request` to evolution-api or wa-automate | Self-hosted bridges. Less reliable for production. |
| SMS | `Twilio` / `Vonage` / `Plivo` | Twilio is the safe default. |
| Slack | `Slack` | Bot vs user token matters — bots can't DM users they don't share a channel with. |
| Telegram | `Telegram` | Bot API; commands and inline keyboards supported. |
| Discord | `Discord` | Webhooks for posting; bot token for fuller features. |

## Payments / commerce

| Use case | Node | Notes |
|---|---|---|
| Stripe | `Stripe` + `Stripe Trigger` | Trigger handles webhook signature verification. Use it instead of `Webhook` + manual HMAC. |
| Shopify | `Shopify` + `Shopify Trigger` | Pre-built event handling. |
| WooCommerce | `WooCommerce` + `WooCommerce Trigger` | Same pattern. |

## Auth

Always use n8n **credentials** for all auth — never inline tokens or keys. Credential types n8n supports natively:

- API Key (header, query string)
- Basic Auth
- OAuth2
- Bearer Token
- Custom (configurable)

When a vendor isn't in n8n's catalog, use `HTTP Request` with a custom Header Auth credential.

## Anti-pattern: nodes to avoid (or use only with care)

- **`Function`** (deprecated, use `Code`)
- **`Read Binary File`** without size limits — easy OOM
- **Plain `Webhook` for Stripe** — use `Stripe Trigger` for built-in HMAC verification
- **`Wait` inside a `Split In Batches` loop** with no `batchSize` cap — runs serially forever on large datasets
- **`HTTP Request` directly to LLM APIs** — use the LangChain LLM nodes; they handle retries and token accounting
