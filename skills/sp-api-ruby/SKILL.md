---
name: sp-api-ruby
description: >-
  Use when researching an Amazon Selling Partner API (SP-API) endpoint (schema, parameters, request/response shape, or known issues and workarounds) or writing efficient SP-API code, including with the peddler Ruby gem.
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

The companion repo `amzn/selling-partner-api-samples` holds reference implementations (per-use-case sample code in Python, Java, JS, C#, PHP) and discussions. The discussions are Amazon-authored guides worth searching: well-architected write-ups on call-volume reduction, 4xx handling, and the Orders v2026 migration. Its issue tracker is sparse and mostly covers bugs in the sample code, so search the models repo for API workarounds, not this one.

```bash
# Browse per-use-case reference implementations to compare against peddler idioms
gh api repos/amzn/selling-partner-api-samples/contents/use-cases --jq '.[].name'

# Read a specific discussion by number
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

Filenames carry the API version (`ordersV0.json`, `orders_2026-01-01.json`). Version identifiers change rarely, but Amazon edits the JSON content behind them on `main` constantly.

## Search the prose docs for behavior the schema omits

The OpenAPI models give you schema and parameters; they do not explain runtime behavior such as rate-limit values, data-availability delays, pagination semantics, or use-case guidance. That lives in Amazon's narrative docs at `developer-docs.amazon.com`, which no repo mirrors. Search it with your own web tools:

```
WebSearch  query: "getOrders data availability delay"  allowed_domains: ["developer-docs.amazon.com"]
# then WebFetch the most promising result and read the prose
```

Reach for this on "how does it behave / why is data missing", not "what is the schema."

## Using the peddler gem?

Research endpoints against the OpenAPI models as above; just know the installed gem can trail Amazon's current spec (an older gem version, or a recent edit peddler has not regenerated yet), so an operation or field in the spec may be missing from your version. Confirm against the gem's generated code (`lib/peddler/apis/`) when it matters. Calling SP-API from Ruby (auth, responses, errors, the `Peddler.<api>` factory) is documented in peddler's README.

## Writing efficient peddler code

When writing or reviewing peddler code, not just researching specs, see [best-practices.md](best-practices.md) for cutting call volume, error and rate-limit handling, reports, caching, and per-API quirks.
