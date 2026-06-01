---
name: sp-api-ruby
description: >-
  Use when researching an Amazon Selling Partner API (SP-API) endpoint (its schema, parameters, request/response shape, or known issues and workarounds in Amazon's OpenAPI models) or writing efficient SP-API code. If the project depends on the peddler gem, also anchor research to the spec the installed gem was generated from.
---

# SP-API spec research

This skill assumes `gh` is installed and authenticated.

Amazon publishes the Selling Partner API as OpenAPI models in `amzn/selling-partner-api-models`. This skill is for researching an endpoint against those models: its schema, parameters, request/response shape, and known issues.

## Research the spec & known issues

Use `gh api` against `amzn/selling-partner-api-models` (no clone needed):

```bash
# Browse model groups, then list spec versions in one
gh api repos/amzn/selling-partner-api-models/contents/models --jq '.[].name'
gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model --jq '.[].name'

# Read a spec or one operation (raw media type; gh's --jq is built in, no separate jq)
gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model/ordersV0.json \
  -H "Accept: application/vnd.github.raw" \
  --jq '.paths["/orders/v0/orders"].get.parameters'

# Search community issues for workarounds and official Amazon responses
gh search issues --repo amzn/selling-partner-api-models "QuotaExceeded" --json number,title,url,state
```

The companion repo `amzn/selling-partner-api-samples` holds reference implementations (per-use-case sample code in Python, Java, JS, C#, PHP) and discussions. The discussions are Amazon-authored guides worth searching: well-architected write-ups on call-volume reduction, 4xx handling, and the Orders v2026 migration, plus announcements like the local SP-API MCP (#382). Its issue tracker is sparse and mostly covers bugs in the sample code, so search the models repo for API workarounds, not this one.

```bash
# Browse per-use-case reference implementations to compare against peddler idioms
gh api repos/amzn/selling-partner-api-samples/contents/use-cases --jq '.[].name'

# Read a specific discussion by number (the SP-API MCP announcement is #382)
gh api repos/amzn/selling-partner-api-samples/discussions/<number>

# Search discussions. There is no `gh search discussions` subcommand,
# so query the GraphQL API:
gh api graphql -f query='
  query($q: String!) {
    search(type: DISCUSSION, query: $q, first: 10) {
      nodes { ... on Discussion { number title url } }
    }
  }' -f q='repo:amzn/selling-partner-api-samples best practices'
```

Filenames carry the API version (`ordersV0.json`, `orders_2026-01-01.json`). Version identifiers change rarely, but Amazon edits the JSON content behind them on `main` constantly. Beware when a project pins an older snapshot.

## Using the peddler gem? Anchor to the installed gem

peddler is generated from a pinned snapshot of these models, so its generated code, not Amazon's `main`, is the source of truth for what the installed gem can call:

```bash
PEDDLER=$(ruby -r peddler -e 'print Gem.loaded_specs["peddler"].gem_dir')   # add `bundle exec` in a Bundler app
ruby -r peddler -e 'puts Peddler::VERSION'
ls "$PEDDLER/lib/peddler/apis"                                              # APIs and versions the gem exposes
```

Operations, parameters, and types are in `"$PEDDLER/lib/peddler/apis/<file>.rb"` and `"$PEDDLER/sig/peddler/apis/"`. Read these before Amazon's spec: the pin freezes spec content at a commit and `main` has drifted within the same version. `grep '@see' "$PEDDLER/lib/peddler/apis/<file>.rb"` shows which spec a class came from, but the URL points at `main`. It locates the file; it does not pin content. Calling SP-API from Ruby (auth, responses, errors, the `Peddler.<api>` factory) is documented in peddler's README.

## Writing efficient peddler code

When writing or reviewing peddler code, not just researching specs, see [best-practices.md](best-practices.md) for concise guidance on cutting call volume, batching, caching, API versions, reports, and per-API quirks.

## Quick reference

| Need | Do this |
|---|---|
| Browse spec groups | `gh api .../contents/models --jq '.[].name'` |
| Read a spec | `gh api .../<spec>.json -H "Accept: application/vnd.github.raw" --jq ...` |
| Find workarounds | `gh search issues --repo amzn/selling-partner-api-models "<term>"` |
| Reference implementations and discussions | `gh api repos/amzn/selling-partner-api-samples/contents/use-cases --jq '.[].name'` |
| Search discussions | `gh api graphql -f query='...search(type: DISCUSSION...)' -f q='repo:amzn/selling-partner-api-samples <term>'` |
| (peddler) installed version | `ruby -r peddler -e 'puts Peddler::VERSION'` |
| (peddler) APIs the gem exposes | `ls "$PEDDLER/lib/peddler/apis"` |
| (peddler) callable params/types | read `"$PEDDLER/lib/peddler/apis/<file>.rb"` or `sig/` |
