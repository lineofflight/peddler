---
name: building-with-peddler
description: >-
  Use when writing, refactoring, or reviewing Ruby code using the peddler gem for Amazon Selling Partner API (SP-API), configuring client authorization, token caching, retries, typed error handling, or pagination.
---

# Building with Peddler

Peddler is an SP-API client generated from Amazon's OpenAPI models. APIs inherit from `Peddler::API` and are accessed via `Peddler.<api>` (latest version) or `Peddler.<api>_<version>` (pinned).

## Quick reference

- Initialize client (with retries):
  `client = Peddler.orders(aws_region, access_token, retries: 3)`
- Pinned API version:
  `client = Peddler.orders_v0(aws_region, access_token)`
- Sandbox mode:
  `client = Peddler.orders(aws_region, access_token).sandbox`
- LWA access token:
  `Peddler::LWA.request(refresh_token:).parse.access_token`
- Restricted Data Token (RDT):
  `Peddler.tokens(...).create_restricted_data_token(restricted_resources:)`

## Authorization & token caching

LWA access tokens and Restricted Data Tokens (RDTs) have a 1-hour lifetime. Cache and reuse them to avoid unnecessary token requests:

```ruby
def current_access_token(refresh_token)
  Rails.cache.fetch("sp_api/lwa_token/#{refresh_token}", expires_in: 50.minutes) do
    Peddler::LWA.request(refresh_token:).parse.access_token
  end
end
```

For PII (buyer name, shipping address, tax info in Orders), request an RDT and batch multiple resource paths in one call rather than requesting an RDT per order.

## Rate limiting & automatic retries

Generated operations already carry Amazon's documented per-operation `rate_limit`. Peddler performs rate-limit-aware exponential backoff with jitter on `429` and transient `5xx` statuses, but only when you set `retries:` on initialization (default is `0`):

```ruby
# Enables automatic backoff pacing; never hand-roll sleep loops
client = Peddler.orders(aws_region, access_token, retries: 3)
```

## Error handling

Peddler raises typed errors under `Peddler::Errors::*` (`QuotaExceeded`, `InvalidInput`, `NotFound`, `AccessDenied`, `Unauthorized`). Rescue `Peddler::Error` and inspect or pattern match on status:

```ruby
begin
  client.get_order(order_id)
rescue Peddler::Error => e
  case e
  in status: 429
    # Throttled beyond retry limit; reschedule later
  in status: 400..499
    # Permanent failure; fix request input or credentials
    logger.error("SP-API client error: #{e.message}")
  in status: 500..599
    # Upstream Amazon outage
  end
end
```

Treat 4xx errors as permanent: do not retry without fixing the underlying request parameters or permissions.

## Pagination

Use a recursive lambda to paginate through collections without mutating loop state:

```ruby
fetch_page = ->(token = nil) {
  res = client.get_orders(marketplace_ids, next_token: token)
  process_orders(res.parse["Orders"])

  if (next_token = res.parse["NextToken"])
    fetch_page.call(next_token)
  end
}
fetch_page.call
```

## Reports and Data Kiosk lifecycle

Reports and Data Kiosk queries are asynchronous 3-step operations:

1. Request: Call `create_report` or `create_query`.
2. Await completion: Listen for `REPORT_PROCESSING_FINISHED` notifications (or poll processing status with exponential backoff if webhooks are not configured).
3. Retrieve: Call `get_report_document` to fetch the document URL, then download the parsed payload.

Prefer reports or Data Kiosk over deep endpoint pagination for historical or bulk data.

## Best practices checklist

- Batching: Use `search_catalog_items` over `get_catalog_item`, and pass `includedData` in `search_orders` instead of making follow-up calls for recipient/financial info.
- Notifications: Subscribe to notifications (`ORDER_CHANGE`, `FEED_PROCESSING_FINISHED`, `REPORT_PROCESSING_FINISHED`) rather than polling endpoints on a timer.
- Caching: Cache slow-changing metadata aggressively (`get_marketplace_participations`, catalog item definitions).
- Modern APIs: Default to unversioned factory methods (`Peddler.orders`, `Peddler.finances`) to use current SP-API specs.
- Sandbox testing: Use `.sandbox` in test environments. Operations that do not support sandbox raise `Peddler::API::CannotSandbox`.
