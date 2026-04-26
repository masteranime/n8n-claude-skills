# n8n Expressions Cheatsheet

n8n expressions are JavaScript-flavored, evaluated per-item, and prefixed with `=` to mark a field as an expression.

## The single most common bug

```
✓  ={{ $json.email }}        // expression — evaluates per item
✗  {{ $json.email }}         // literal string — sent as-is to the destination
```

Without the leading `=`, n8n treats the entire value as a literal string. The UI hides this — always check the JSON view if expressions aren't interpolating.

## Accessing data

```javascript
// Current item's JSON
{{ $json.field }}
{{ $json.nested.field }}
{{ $json["field-with-dash"] }}        // bracket notation for non-identifier keys

// Optional chaining for safety
{{ $json.customer?.email ?? 'unknown' }}

// Array access
{{ $json.items[0].name }}
{{ $json.items?.[0]?.name ?? '' }}

// All items in current node input
{{ $input.all() }}              // array of { json, binary }
{{ $input.first().json.x }}
{{ $input.last().json.x }}
{{ $input.item.json.x }}        // current item being processed

// Output of a previous node
{{ $('Webhook').item.json.body.email }}
{{ $('Set').first().json.id }}
{{ $('Split In Batches').all().map(i => i.json.id) }}
```

Use the exact node name including spaces, in single or double quotes.

## Built-in helpers

```javascript
// Date / time (Luxon)
{{ $now }}                              // current DateTime
{{ $now.toISO() }}                      // 2026-04-26T12:34:56.000Z
{{ $now.toFormat('yyyy-MM-dd') }}       // 2026-04-26
{{ $now.minus({ days: 7 }).toISO() }}   // 1 week ago
{{ $now.plus({ hours: 2 }) }}
{{ DateTime.fromISO($json.timestamp) }} // parse ISO string

// Today's start / end
{{ $today.startOf('day').toISO() }}
{{ $today.endOf('day').toISO() }}

// Environment vars (self-hosted)
{{ $env.MY_SECRET }}

// Workflow + execution metadata
{{ $workflow.id }}
{{ $workflow.name }}
{{ $execution.id }}
{{ $execution.mode }}            // 'webhook' | 'manual' | 'trigger' | etc.

// Item index in the current batch
{{ $itemIndex }}

// Run index (incremented on each manual run)
{{ $runIndex }}
```

## String operations

```javascript
{{ $json.name.trim() }}
{{ $json.name.toLowerCase() }}
{{ $json.email.split('@')[1] }}                  // extract domain
{{ $json.text.replace(/\s+/g, ' ') }}            // collapse whitespace
{{ $json.title.startsWith('Sr.') }}
{{ `Hello ${$json.name}, your code is ${$json.code}` }}  // template literal
```

## Number / math

```javascript
{{ $json.amount * 1.07 }}
{{ Math.round($json.score * 100) / 100 }}        // 2 decimals
{{ Number($json.price.replace(/,/g, '')) }}      // string with commas → number
{{ Math.max($json.a, $json.b) }}
```

## Boolean / conditional

```javascript
{{ $json.amount > 100 ? 'high' : 'low' }}
{{ $json.status === 'paid' && $json.shipped }}
{{ !$json.disabled }}
```

## Arrays

```javascript
{{ $json.items.length }}
{{ $json.items.filter(i => i.active) }}
{{ $json.items.map(i => i.id) }}
{{ $json.items.reduce((sum, i) => sum + i.price, 0) }}
{{ $json.items.find(i => i.id === '123') }}
{{ $json.items.includes('foo') }}
```

## JSON

```javascript
{{ JSON.stringify($json) }}
{{ JSON.parse($json.payload_string) }}
```

## Common patterns

### Build a SQL-friendly value

```sql
INSERT INTO orders (id, email, amount, created_at)
VALUES (
  '{{ $json.order_id }}',
  '{{ $json.email.toLowerCase() }}',
  {{ $json.amount }},
  '{{ $now.toISO() }}'
)
```

### Compute an idempotency key

```javascript
={{ require('crypto').createHash('sha256').update(JSON.stringify($json)).digest('hex') }}
```

(Available in `Code` node, not in expressions — copy logic into a `Code` node and pass through.)

### Conditional API URL

```javascript
={{ $json.env === 'prod' ? 'https://api.example.com' : 'https://staging.api.example.com' }}/v1/users/{{ $json.user_id }}
```

### Default values

```javascript
={{ $json.email ?? $json.contact_email ?? 'no-email@unknown.com' }}
```

### Safe nested access with fallbacks

```javascript
={{ $json.user?.profile?.address?.city ?? 'Unknown' }}
```

## Gotchas

- **Whole field is the expression**: a field is either fully literal or fully an expression — you can't put `=` in the middle. To mix literals and expressions, use template literals: `={{ \`Hello ${$json.name}\` }}`.
- **Quoting**: inside expressions, use single quotes for strings to avoid escaping. Double quotes work too but conflict with JSON.
- **`$node`** is deprecated. Use `$('Node Name')` instead.
- **No top-level `await`** in expressions. For async logic, use a `Code` node.
- **`require()`** only works in `Code` node, not in expressions.
- **Date arithmetic** uses Luxon, not native `Date`. `.minus({ days: 7 })`, not `.setDate(...)`.

## Code node specifics

```javascript
// Run Once for All Items mode
const items = $input.all();
return items.map(item => ({
  json: { ...item.json, processed: true }
}));

// Run Once for Each Item mode (cleaner for per-item)
return {
  json: { ...$json, doubled: $json.amount * 2 }
};
```

In `Code`, use `$input.all()` and return an array of `{ json: {...}, binary: {...} }` objects. n8n turns each into a downstream item.

## When expressions fail silently

The most insidious case: a typo in a field name returns `undefined`, which n8n stringifies as `"undefined"`. Always log the input shape during development by inserting a `Set` node with `={{ JSON.stringify($json) }}` to verify the structure.
