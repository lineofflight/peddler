---
name: building-with-peddler
description: >-
  Use when writing, refactoring, or reviewing Ruby code using the peddler gem for Amazon Selling Partner API (SP-API): creating a client, access tokens and token caching, retries, error handling, pagination, or downloading reports and uploading feeds.
---

# Building with Peddler

Peddler is an SP-API client generated from Amazon's OpenAPI models. A single `Peddler::Client` reaches every API: `client.<api>` is the latest version and `client.<api>_<version>` a pinned one.

This describes Peddler 6. Peddler 5 had a class per API (`Peddler.orders.new(aws_region, access_token)`), `Peddler::LWA.request` and `Peddler::Errors::*`. Check the version in `Gemfile.lock` before you write code, and see `UPGRADING.md` in the gem to move from 5 to 6.

## Quick reference

- Create a client (with retries):
  `client = Peddler::Client.new(region: "eu-west-1", access_token: token, retries: 3)`
- Latest or pinned API version:
  `client.orders`, `client.orders_v0`
- Call an operation, required arguments in order and optional ones as keywords:
  `client.orders_v0.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z")`
- Send a body as a Hash with Amazon's field names:
  `client.reports.create_report({ "reportType" => type, "marketplaceIds" => marketplace_ids })`
- Marketplace IDs:
  `Peddler::Marketplace.ids("UK", "DE")`
- Read a response:
  `response.parse` (typed model), `response.to_h`, `response.dig("payload", "Orders")`, `response.status.success?`
- Sandbox, as a new client:
  `sandbox = client.sandbox`
- LWA access token:
  `Peddler::LWA.new.refresh(refresh_token: token).access_token`
- Restricted Data Token (RDT):
  `client.tokens.create_restricted_data_token(body)`, then `client.with_access_token(rdt)`
- Call an endpoint that has no method yet, with parameter values as an operation takes them:
  `client.request("GET", "/orders/v0/orders", params: { MarketplaceIds: marketplace_ids })`
- Operation documentation and signatures:
  YARD comments in `lib/peddler/native/apis.rb` and `sig/peddler/native/apis.rbs` in the gem

## Authorization & token caching

The client sends the token it is given and never requests one. LWA access tokens and Restricted Data Tokens (RDTs) have a 1-hour lifetime. Cache and reuse them: pass the client a callable around your cache, which it calls before every request.

```ruby
lwa = Peddler::LWA.new # reads LWA_CLIENT_ID and LWA_CLIENT_SECRET
client = Peddler::Client.new(
  region: "eu-west-1",
  access_token: -> {
    Rails.cache.fetch("sp_api/lwa_token/#{seller.id}", expires_in: 50.minutes) do
      lwa.refresh(refresh_token: seller.refresh_token).access_token
    end
  },
)
```

In a single process, `lwa.token_source(refresh_token: seller.refresh_token)` is a ready-made callable that keeps 1 token in memory. It is not shared between processes.

Create clients when you need them, in the job or the request. Creating one is cheap, and a client or a `Peddler::LWA` created before `fork` raises `Peddler::ForkError` in the child.

For PII (buyer name, shipping address, tax info in Orders), request an RDT and batch multiple resource paths in 1 call rather than requesting an RDT per order.

```ruby
rdt = client.tokens.create_restricted_data_token({
  "restrictedResources" => order_ids.map { |id| { "method" => "GET", "path" => "/orders/v0/orders/#{id}/address" } },
}).parse.restricted_data_token

restricted = client.with_access_token(rdt)
addresses = order_ids.map { |id| restricted.orders_v0.get_order_address(id).parse.payload.shipping_address }
```

## Rate limiting & automatic retries

Peddler does not pace calls. Spread them out in the application, for example with the job queue's rate limiting. The `x-amzn-RateLimit-Limit` response header carries the limit of an operation.

With `retries:` (default `0`, at most `10`), the client retries a `429` whatever the method, and a GET on `500`, `502`, `503`, `504`, a failed connection or a timeout.

```ruby
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token, retries: 3)
```

After a `429` it waits by the rate Amazon documents for the operation: 1 / rate seconds, doubling. That is 2, 4 and 8 seconds at 0.5 requests a second, and 60, 120 and 240 at 1 request a minute. After a failure it waits up to 1 second, then 1 to 2, then 3 to 4. A `Retry-After` header replaces either wait.

A wait longer than 10 minutes ends retrying, and the last response raises. So an operation limited to 1 request a minute is retried 4 times at most, whatever `retries:` says.

`timeout:` (30 seconds) limits each attempt, not the waits between them. A throttled call with `retries: 3` can hold its thread for minutes, so keep `retries:` at `0` in a web request and let a background job wait. For a `429` that survives the retries, reschedule the job. Never sleep in a loop.

A request that changes data is retried after a `429` only, since Amazon did not process it. After a `5xx` or no response it may have been processed: reschedule the job, and make it safe to run twice.

## Error handling

Every response outside 2xx raises `Peddler::Error`, with `status`, Amazon's `code` (such as `"QuotaExceeded"` or `"InvalidInput"`), `message`, `request_id` and `response`. Pattern match on `status` and `code`:

```ruby
begin
  client.orders_v0.get_order(order_id)
rescue Peddler::Error => e
  case e
  in status: 429
    # Throttled beyond retry limit; reschedule later
    reschedule
  in status: 400..499
    # Permanent failure; fix request input or credentials
    logger.error("SP-API #{e.code}: #{e.message} (request #{e.request_id})")
  in status: 500..599
    # Upstream Amazon outage
    reschedule
  end
rescue Peddler::TransportError
  # No response: a failed connection or a timeout
  reschedule
end
```

Treat 4xx errors as permanent: do not retry without fixing the underlying request parameters or permissions.

Not every failure is a `Peddler::Error`. `Peddler::TransportError` (and its subclass `Peddler::TimeoutError`) means no response arrived. `Peddler::AuthenticationError` means Login with Amazon rejected a token request: its `code` `"invalid_grant"` means the seller must authorize again. `ArgumentError` means an option or argument broke its rule and nothing was sent. Its message names it, such as `order_id is required`.

## Pagination

Operations that return a page token have a `_pages` twin with the same arguments. It returns a lazy Enumerator of responses and requests each page when asked:

```ruby
client.orders_v0.get_orders_pages(marketplace_ids, created_after: "2026-01-01T00:00:00Z").each do |page|
  process(page.parse.payload.orders)
end
```

Don't write a token loop where a `_pages` method exists.

## Reports and Data Kiosk lifecycle

Reports and Data Kiosk queries are asynchronous 3-step operations:

1. Request: Call `create_report` or `create_query`.
2. Await completion: Listen for `REPORT_PROCESSING_FINISHED` notifications. Without notifications, `client.reports.wait_for_report(report_id)` and `client.data_kiosk.wait_for_query(query_id)` poll in a background job.
3. Retrieve: Stream the document by its ID with `client.reports.open_report_document` or `client.data_kiosk.open_query_document`.

These helpers are on the API they belong to, beside its operations: `client.reports`, `client.feeds` and `client.data_kiosk`.

```ruby
report_id = client.reports.create_report({
  "reportType" => "GET_MERCHANT_LISTINGS_ALL_DATA",
  "marketplaceIds" => marketplace_ids,
}).parse.report_id

report = client.reports.wait_for_report(report_id, timeout: 900).parse
raise "report #{report.processing_status}" unless report.processing_status == "DONE"

client.reports.open_report_document(report.report_document_id) do |document|
  document.each_tsv { |row| process(row) }
end
```

`each_tsv` yields each row as an Array of UTF-8 Strings, the column names first. `each_jsonl` yields each parsed line of a Data Kiosk document. For a small document, `client.reports.download_report_document(id).to_s` returns it whole.

A wait that runs past its `timeout:` raises `Peddler::WorkflowTimeoutError`: reschedule the job and wait again. A download that runs past its own raises `Peddler::DocumentTimeoutError`. A single request that takes too long, such as 1 poll or looking a document up, raises `Peddler::TimeoutError`.

To submit a feed, upload its content with `client.feeds.create_and_upload_feed_document(io, content_type:)`, pass the returned ID to `client.feeds.create_feed` as `inputFeedDocumentId`, then `client.feeds.wait_for_feed(feed_id)`. A String, and a source that answers `size`, such as a File or a StringIO, are sent with their length. For another source, pass `content_length:`.

Prefer reports or Data Kiosk over deep endpoint pagination for historical or bulk data.

## Best practices checklist

- Batching: Use `search_catalog_items` over `get_catalog_item`, and pass `included_data:` in `search_orders` instead of making follow-up calls for recipient/financial info.
- Notifications: Subscribe to notifications (`ORDER_CHANGE`, `FEED_PROCESSING_FINISHED`, `REPORT_PROCESSING_FINISHED`) rather than polling endpoints on a timer.
- Caching: Cache slow-changing metadata aggressively (`get_marketplace_participations`, catalog item definitions).
- Modern APIs: Default to unversioned methods (`client.orders`, `client.finances`) to use current SP-API specs.
- Sandbox testing: Use `client.sandbox` in test environments, and keep its return value: it leaves `client` on production. To test against a local server, create the client with `base_url: "http://localhost:9001"` in place of `region:`. WebMock and VCR don't see Peddler's requests, so don't stub them there.
