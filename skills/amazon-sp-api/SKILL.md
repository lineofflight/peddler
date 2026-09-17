---
name: amazon-sp-api
description: >-
  Use when researching an Amazon Selling Partner API (SP-API) endpoint (schema, parameters, request/response shape, or known issues and workarounds), or searching official SP-API documentation and developer discussions.
---

# Amazon Selling Partner API (SP-API)

Use or install `gh` preferably.

Amazon publishes the Selling Partner API as OpenAPI models in `amzn/selling-partner-api-models` and sample code with architectural write-ups in `amzn/selling-partner-api-samples`.

## Find the spec file

Locate OpenAPI models in `amzn/selling-partner-api-models` by operation ID or endpoint path:

- Find by operation ID:
  `gh search code --repo amzn/selling-partner-api-models "operationId: confirmShipment"`
- Find by endpoint path:
  `gh search code --repo amzn/selling-partner-api-models '"/orders/v0/orders"'`

## Inspect schema and parameters

Fetch raw JSON models with `gh api` and query paths or schemas with built-in `--jq`. The raw accept header bypasses base64 encoding:

- Operation parameters:
  `gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model/ordersV0.json -H "Accept: application/vnd.github.raw" --jq '.paths["/orders/v0/orders"].get.parameters'`
- Schema definition:
  `gh api repos/amzn/selling-partner-api-models/contents/models/orders-api-model/ordersV0.json -H "Accept: application/vnd.github.raw" --jq '.definitions.Order'`

## Search issues and workarounds

Search `amzn/selling-partner-api-models` for known bugs, error codes, and official Amazon workarounds across open and closed issues:

- Search issues:
  `gh search issues --repo amzn/selling-partner-api-models "<term>" --json number,title,url,state`

## Reference implementations and discussions

The `amzn/selling-partner-api-samples` repo contains reference code and Amazon-authored architecture guides:

- Browse use-case code:
  `gh api repos/amzn/selling-partner-api-samples/contents/use-cases --jq '.[].name'`
- Search discussions via GraphQL:
  `gh api graphql -f query='query($q: String!) { search(type: DISCUSSION, query: $q, first: 10) { nodes { ... on Discussion { number title url } } } }' -f q='repo:amzn/selling-partner-api-samples call volume'`
- Read discussion body:
  `gh api repos/amzn/selling-partner-api-samples/discussions/187 --jq .body`

## Search narrative documentation

OpenAPI models omit operational constraints like propagation delays and rate limits. Search `developer-docs.amazon.com/sp-api` using web queries:

- Data propagation delay:
  `site:developer-docs.amazon.com/sp-api getOrders data availability delay`
- Rate limits and quotas:
  `site:developer-docs.amazon.com/sp-api reports rate limits`
- Notification setup:
  `site:developer-docs.amazon.com/sp-api notifications overview`
