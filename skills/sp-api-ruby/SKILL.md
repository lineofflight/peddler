---
name: sp-api-ruby
description: >-
  Use when researching an Amazon Selling Partner API (SP-API) endpoint: its schema, parameters, request/response shape, or known issues and workarounds in Amazon's OpenAPI models. If the project depends on the peddler gem, also anchor research to the spec the installed gem was generated from.
---

# SP-API spec research

Amazon publishes the Selling Partner API as OpenAPI models in `amzn/selling-partner-api-models`. This skill is for researching an endpoint against those models: its schema, parameters, request/response shape, and known issues.

## Research the spec & known issues

Use `gh api` against `amzn/selling-partner-api-models` — no clone needed:

```bash
# Browse model groups, then list spec versions in one
gh api repos/amzn/selling-partner-api-models/contents/models --jq '.[].name'
gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model --jq '.[].name'

# Read a spec / one operation (raw media type; gh's --jq is built in, no separate jq)
gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model/ordersV0.json \
  -H "Accept: application/vnd.github.raw" \
  --jq '.paths["/orders/v0/orders"].get.parameters'

# Search community issues for workarounds & official Amazon responses
gh search issues --repo amzn/selling-partner-api-models "getOrders 429" --json number,title,url,state
```

`gh` and `jq` are both soft dependencies: `gh`'s `--jq` is built in, so no separate `jq` is needed; with no `gh` at all the specs are public — fetch the raw URL with `curl -s` or the WebFetch tool and read the JSON directly: `https://raw.githubusercontent.com/amzn/selling-partner-api-models/main/models/<group>/<spec>.json`

Filenames carry the API version (`ordersV0.json`, `orders_2026-01-01.json`). Version identifiers change rarely, but Amazon edits the JSON *content* behind them on `main` constantly. Beware when a project pins an older snapshot.

## Using the peddler gem? Anchor to the installed gem

peddler is generated from a pinned snapshot of these models, so its generated code — not Amazon's `main` — is the source of truth for what the installed gem can call:

```bash
PEDDLER=$(ruby -r peddler -e 'print Gem.loaded_specs["peddler"].gem_dir')   # add `bundle exec` in a Bundler app
ruby -r peddler -e 'puts Peddler::VERSION'
ls "$PEDDLER/lib/peddler/apis"                                              # APIs + versions the gem exposes
```

Operations, parameters, and types are in `"$PEDDLER/lib/peddler/apis/<file>.rb"` and `"$PEDDLER/sig/peddler/apis/"`. Read these before Amazon's spec: the pin freezes spec content at a commit and `main` has drifted within the same version. `grep '@see' "$PEDDLER/lib/peddler/apis/<file>.rb"` shows which spec a class came from, but the URL points at `main`. It locates the file, it does not pin content. Calling SP-API from Ruby (auth, responses, errors, the `Peddler.<api>` factory) is documented in peddler's README.

## Quick reference

| Need | Do this |
|---|---|
| Browse spec groups | `gh api .../contents/models --jq '.[].name'` |
| Read a spec | `gh api .../<spec>.json -H "Accept: application/vnd.github.raw" --jq …` |
| Find workarounds | `gh search issues --repo amzn/selling-partner-api-models "<term>"` |
| No `gh` | `curl -s https://raw.githubusercontent.com/.../<spec>.json` or WebFetch |
| (peddler) installed version | `ruby -r peddler -e 'puts Peddler::VERSION'` |
| (peddler) APIs the gem exposes | `ls "$PEDDLER/lib/peddler/apis"` |
| (peddler) callable params/types | read `"$PEDDLER/lib/peddler/apis/<file>.rb"` / `sig/` |
