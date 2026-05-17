---
name: peddler
description: >-
  Use when working with the Amazon Selling Partner API (SP-API) from Ruby in a
  project that depends on the peddler gem: researching an SP-API endpoint's
  schema, parameters, request/response shape, or known issues and workarounds in
  Amazon's OpenAPI models, or writing authenticated SP-API calls (LWA tokens,
  marketplaces, response parsing, error handling, sandbox).
---

# Peddler: SP-API research & Ruby usage

Peddler is a Ruby gem that wraps Amazon's Selling Partner API (SP-API), generated
from Amazon's OpenAPI models. This skill helps you **research the SP-API spec**
and **call it correctly through peddler**.

**Core principle: anchor to the installed gem first.** Amazon's `main` branch is
usually ahead of what peddler ships. Research the spec version peddler actually
wraps, not Amazon's latest, or you will document parameters and fields that the
installed gem cannot call.

## 1. Anchor to the installed peddler (do this first)

Find the installed gem and its real API surface — no peddler checkout required:

```bash
PEDDLER=$(ruby -r peddler -e 'print Gem.loaded_specs["peddler"].gem_dir')   # add `bundle exec` in a Bundler app
ruby -r peddler -e 'puts Peddler::VERSION'                                   # installed version
ls "$PEDDLER/lib/peddler/apis"                                              # every API + version it exposes
```

Filenames are version anchors: `orders_v0.rb`, `orders_2026_01_01.rb`. Each
generated class names its source spec in a `@see` comment — that is the exact
spec file (and branch) peddler generated from:

```bash
grep '@see https://github.com/amzn' "$PEDDLER/lib/peddler/apis/orders_v0.rb"
```

Why it matters: `Peddler.orders` → `Peddler::APIs::Orders20260101` (spec
`orders_2026-01-01.json`), but `Peddler.orders_v0` → `Peddler::APIs::OrdersV0`
(spec `ordersV0.json`). Same API group, two specs. Research the one matching the
class you call.

## 2. Research SP-API specs & issues

Use `gh api` against `amzn/selling-partner-api-models` — no local clone needed.
The vendored spec directory is gitignored and absent from the gem; never depend
on it.

```bash
# Browse all API model groups
gh api repos/amzn/selling-partner-api-models/contents/models --jq '.[].name'

# List spec versions in one group
gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model --jq '.[].name'

# Read a spec without cloning (raw media type → pipe straight to jq)
gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model/ordersV0.json \
  -H "Accept: application/vnd.github.raw" --jq '.info.version, (.paths | keys)'

# Inspect one operation's parameters / schema
gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model/ordersV0.json \
  -H "Accept: application/vnd.github.raw" \
  --jq '.paths["/orders/v0/orders"].get.parameters'

# Search community issues for workarounds & official Amazon responses
gh search issues --repo amzn/selling-partner-api-models "getOrders 429" --json number,title,url,state
```

`gh api` defaults to `main` (Amazon's latest). If step 1 shows peddler wrapped
an older spec, fetch that file by name from `main` — it is the same path; the
filename itself is the version.

## 3. Call SP-API from Ruby via peddler

**Operation → class.** Don't hand-derive class names. Every API has a factory on
the `Peddler` module; `Peddler.<api>` is the latest version, `Peddler.<api>_<version>`
is explicit:

```ruby
Peddler.orders_v0  # => Peddler::APIs::OrdersV0
Peddler.orders     # => latest version peddler wraps
```

List factories with `ruby -r peddler -e 'puts Peddler.singleton_methods.sort'`.
OpenAPI operation IDs become snake_case methods (`getOrders` → `get_orders`);
signatures live in `"$PEDDLER/lib/peddler/apis/<file>.rb"` or `sig/peddler/apis/`.

**Full authenticated call** with response and error handling:

```ruby
require "peddler"

# ENV holds LWA_CLIENT_ID / LWA_CLIENT_SECRET; the selling partner gives you a refresh token.
access_token = Peddler::LWA.request(refresh_token: ENV.fetch("REFRESH_TOKEN")).parse.access_token

# aws_region: "us-east-1" (North America), "eu-west-1" (Europe), "us-west-2" (Far East)
api = Peddler.orders_v0.new("us-east-1", access_token, retries: 3)

begin
  response = api.get_orders(
    Peddler::Marketplace.ids("US", "UK"),     # => ["ATVPDKIKX0DER", "A1F83G8C2ARO7P"]
    created_after: "2024-01-01T00:00:00Z",
  )

  orders = response.parse.payload.orders        # typed Data objects (lazy-loaded)
  # response.dig("payload", "orders")           # plain Hash access
  # response.to_h                               # raw Hash
  raise "request failed" unless response.status.success?
rescue Peddler::Error => e
  # All 4xx/5xx raise Peddler::Error; subclasses live under Peddler::Errors::*
  # (NotFound, Unauthorized, QuotaExceeded, InvalidInput, AccessDenied, …).
  warn "#{e.class}: #{e.message} (HTTP #{e.response.status})"
  retry if e.response.status >= 500            # transient; or rescue Peddler::Errors::QuotaExceeded for 429
  raise
end
```

- **Sandbox:** `api.sandbox.get_orders(...)` hits Amazon's static sandbox.
- **PII / restricted operations** need a Restricted Data Token; see peddler's
  README "Restricted Data Tokens (RDT) and PII".
- **Rate limits:** pass `rate_limit:` per call; `retries:` on `.new` enables
  exponential backoff on 429.

## Quick reference

| Need | Do this |
|---|---|
| Installed version | `ruby -r peddler -e 'puts Peddler::VERSION'` |
| What APIs/versions exist | `ls "$PEDDLER/lib/peddler/apis"` |
| Which spec a class wraps | `grep '@see' "$PEDDLER/lib/peddler/apis/<file>.rb"` |
| Browse spec groups | `gh api .../contents/models --jq '.[].name'` |
| Read a spec | `gh api .../<spec>.json -H "Accept: application/vnd.github.raw" --jq …` |
| Find workarounds | `gh search issues --repo amzn/selling-partner-api-models "<term>"` |
| Get a class | `Peddler.<api>` or `Peddler.<api>_<version>` |
| Auth | `Peddler::LWA.request(refresh_token:).parse.access_token` |
| Marketplace IDs | `Peddler::Marketplace.ids("US", "DE")` |
| Response | `.parse` (typed) / `.dig` / `.to_h` / `.status` |
| Errors | rescue `Peddler::Error`; branch on `e.response.status` |

## Common mistakes

- **Researching Amazon's `main` and assuming peddler matches.** It often
  doesn't. Do step 1 first; research the spec the installed class wraps.
- **Referencing the vendored `selling-partner-api-models/` directory.** It is
  gitignored and not shipped in the gem. Use `gh api` only.
- **Hand-deriving class names** like `Peddler::APIs::OrdersV0`. Use the
  `Peddler.<api>[_<version>]` factory; the casing/date rules are non-obvious.
- **Catching a narrow error class.** Rescue `Peddler::Error` (the base) and
  branch on `e.response.status`; subclasses are created dynamically.
