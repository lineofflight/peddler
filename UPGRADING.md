# Upgrading Peddler

This guide covers upgrading from v5.x to v6.0, and from v4.x to v5.0.

## From v5.x to v6.0

Peddler 6 sends its requests through a Rust core that ships with the gem as a native extension. Its Ruby API stays close to v5. You change how you create a client, how you get tokens and how you rescue errors. Your operation calls stay as they are.

### What to change

#### 1. Creating a client

A single `Peddler::Client` replaces the API classes. Create it once and reach each API through a method.

**Before (v5):**
```ruby
api = Peddler.orders_v0.new("eu-west-1", access_token, retries: 3)
response = api.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z")
```

**After (v6):**
```ruby
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token, retries: 3)
response = client.orders_v0.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z")
```

`client.orders` is the latest version of an API, as `Peddler.orders` was, and `client.orders_v0` a pinned one.

1 of them moved since 5.5.0. `fulfillment_outbound` is now Fulfillment Outbound 2026-07-04, which has `create_order` where 2020-07-01 had `create_fulfillment_order`. To stay on the older version, call `client.fulfillment_outbound_2020_07_01`.

`Peddler.<api>` and `Peddler::APIs::OrdersV0.new` are gone. `Peddler::APIs::OrdersV0` is now a module that holds the typed models, so `Peddler::APIs::OrdersV0::Order` still works.

The `http:` option is gone, with the `http` gem. A client takes `timeout:`, the seconds a whole call may take. The default is 30, where v5 had none.

An option that breaks its rule raises `ArgumentError` that names it, such as `retries must be an Integer between 0 and 10` or `region must be one of us-east-1, us-west-2, eu-west-1`.

To send another token, v5 created another API object. v6 takes a view of the client, which shares its connections.

**Before (v5):**
```ruby
api = Peddler.orders_v0.new("eu-west-1", restricted_data_token)
```

**After (v6):**
```ruby
restricted = client.with_access_token(restricted_data_token)
restricted.orders_v0.get_order_address("123-1234567-1234567")
```

After `fork`, create clients in the child process. A client created before the fork raises `Peddler::ForkError` there.

#### 2. Tokens and LWA

`Peddler::LWA.request` is gone. Create a `Peddler::LWA` and call the grant you need. Each returns the tokens, not a response to parse.

**Before (v5):**
```ruby
access_token = Peddler::LWA.request(refresh_token: refresh_token).parse.access_token
refresh_token = Peddler::LWA.request(code: code).parse.refresh_token
access_token = Peddler::LWA.request(scope: "sellingpartnerapi::notifications").parse.access_token
```

**After (v6):**
```ruby
lwa = Peddler::LWA.new
access_token = lwa.refresh(refresh_token: refresh_token).access_token
refresh_token = lwa.exchange_authorization_code(code: code).refresh_token
access_token = lwa.client_credentials(scope: "sellingpartnerapi::notifications").access_token
```

`Peddler::LWA.new` reads `LWA_CLIENT_ID` and `LWA_CLIENT_SECRET` from the environment, or takes `client_id:` and `client_secret:`, as before. `Peddler::LWAToken` is now `Peddler::LWA::Tokens`, with the same `access_token`, `refresh_token`, `token_type`, `expires_in` and `scope`.

The readers `client_id`, `client_secret`, `options` and `grant_type` of a `Peddler::LWA`, and `Peddler::LWA::URL`, are gone. A grant with a blank argument raises `ArgumentError` that names it, such as `refresh_token must be a UTF-8 String that is not blank`, and sends nothing.

A rejected token request raises `Peddler::AuthenticationError`, which is not a `Peddler::Error`. It has `status` and `code`, such as `"invalid_grant"`. Its message is `authentication rejected (400)`, with the status: the description Amazon sends, which was v5's message, is not kept.

**Before (v5):**
```ruby
begin
  Peddler::LWA.request(refresh_token: refresh_token)
rescue Peddler::Errors::InvalidGrant
  reconnect_seller
end
```

**After (v6):**
```ruby
begin
  lwa.refresh(refresh_token: refresh_token)
rescue Peddler::AuthenticationError => e
  reconnect_seller if e.code == "invalid_grant"
end
```

The client still sends the token you give it and requests none itself. What is new is that the token may be a callable. Keep the cache you have, and the client asks it before every request.

**Before (v5):**
```ruby
access_token = Rails.cache.fetch("lwa/#{seller.id}", expires_in: 55.minutes) do
  Peddler::LWA.request(refresh_token: seller.refresh_token).parse.access_token
end
api = Peddler.orders_v0.new("eu-west-1", access_token)
```

**After (v6):**
```ruby
client = Peddler::Client.new(
  region: "eu-west-1",
  access_token: -> {
    Rails.cache.fetch("lwa/#{seller.id}", expires_in: 55.minutes) do
      lwa.refresh(refresh_token: seller.refresh_token).access_token
    end
  },
)
```

Passing the String, as in v5, still works.

#### 3. Errors

`Peddler::Errors` and its class per Amazon error code are gone. Every HTTP error raises `Peddler::Error`. Match on its `code` where you rescued a class.

If you defined such a class ahead of time, as the v5 README suggested for a new error code (`module Peddler; module Errors; class NewAmazonErrorCode < Error`), delete it. It still loads, and a `rescue` of it never matches.

**Before (v5):**
```ruby
begin
  api.get_order(order_id)
rescue Peddler::Errors::QuotaExceeded
  backoff_and_retry
rescue Peddler::Errors::InvalidInput => e
  logger.error(e.message)
end
```

**After (v6):**
```ruby
begin
  client.orders_v0.get_order(order_id)
rescue Peddler::Error => e
  case e
  in code: "QuotaExceeded" then backoff_and_retry
  in code: "InvalidInput" then logger.error(e.message)
  else raise
  end
end
```

`message` and `response` work as in v5. `status`, `code` and `request_id` are new, and an error matches patterns on `status` and `code`. `e.response.status` still works.

**Before (v5):**
```ruby
begin
  api.get_order(order_id)
rescue Peddler::Error => e
  retry_later if e.response.status >= 500
end
```

**After (v6):**
```ruby
begin
  client.orders_v0.get_order(order_id)
rescue Peddler::Error => e
  retry_later if e.status >= 500
end
```

With `retries:` set, a request that still fails after the last retry raises the same `Peddler::Error`. v5 raised `HTTP::OutOfRetriesError`.

**Before (v5):**
```ruby
begin
  api.get_order(order_id)
rescue HTTP::OutOfRetriesError
  retry_later
end
```

**After (v6):**
```ruby
begin
  client.orders_v0.get_order(order_id)
rescue Peddler::Error => e
  retry_later if e.status == 429
end
```

A request that gets no response no longer raises the `http` gem's errors.

**Before (v5):**
```ruby
begin
  api.get_order(order_id)
rescue HTTP::TimeoutError
  retry_later
rescue HTTP::ConnectionError
  retry_later
end
```

**After (v6):**
```ruby
begin
  client.orders_v0.get_order(order_id)
rescue Peddler::TimeoutError
  retry_later
rescue Peddler::TransportError
  retry_later
end
```

`Peddler::TimeoutError` is a `Peddler::TransportError`. Neither is a `Peddler::Error`. The [README](README.md#error-handling) lists every error class.

#### 4. Sandbox

In v5, `sandbox` switched the API object to the sandbox for good. In v6, it returns a new client and leaves the one you call it on in production. Use the return value.

**Before (v5):**
```ruby
api = Peddler.orders_v0.new("eu-west-1", access_token)
api.sandbox
api.get_orders(marketplace_ids, created_after: "TEST_CASE_200") # sandbox
```

**After (v6):**
```ruby
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token)
sandbox = client.sandbox
sandbox.orders_v0.get_orders(marketplace_ids, created_after: "TEST_CASE_200") # sandbox
client.orders_v0.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z") # production
```

`Peddler::API::CannotSandbox` and `Peddler::API::MustSandbox` are gone. Peddler no longer checks whether an operation supports the sandbox. Amazon answers such a call with an error, which raises `Peddler::Error`.

#### 5. `rate_limit:`

Operations no longer take `rate_limit:`. Passing it raises `ArgumentError`. Remove it.

**Before (v5):**
```ruby
api.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z", rate_limit: 0.5)
```

**After (v6):**
```ruby
client.orders_v0.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z")
```

`retries:` stays, and differs in 3 ways.

- **What it retries.** v6 retries a GET, when Amazon answers 429, 500, 502, 503 or 504. v5 retried every method, also a request that changes data, and also a failed connection.
- **How long it waits.** After a 429, v5 waited 1 / rate limit seconds, doubling each time: 2, 4 and 8 seconds for an operation limited to 0.5 requests a second, and 60, 120 and 240 for one limited to 1 a minute. After a 5xx it waited up to 1 second, then up to 2, then up to 4. v6 waits a random time after either: up to 0.2 seconds before the first retry, up to 0.4 before the second, up to 0.8 before the third, and so on, doubling up to 30 seconds. So `retries: 3` waits 1.4 seconds at most, where v5 waited 14 seconds or 7 minutes on those 2 throttled operations.
- **`Retry-After`.** If the response has the header, both wait as long as it asks. But if it asks for more than 30 seconds, or for more time than the call has left, v6 doesn't retry. v5 waited whatever it asked.

`retries:` takes 0 to 10, and a single `timeout:` covers every attempt and every wait.

If you relied on `retries:` to wait out a throttled operation, it no longer does that. Rescue the error and run the work again later.

```ruby
begin
  client.orders_v0.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z")
rescue Peddler::Error => e
  e.status == 429 ? retry_later : raise
end
```

### What keeps working

- Method names and signatures. Required arguments are positional, in the same order, and optional ones are keywords with the same names.
- The forms an argument may take, listed under [Argument forms](#argument-forms): a String for a list, a String that holds JSON for a body, a number where a String is expected and a numeric String where a number is.
- A `Peddler::Marketplace` wherever its ID goes, alone or in a list, and any other object that converts itself with `to_str`.
- The documentation of every operation and API class, as YARD comments.
- `parse`, `to_h` and `dig` on a response, and the typed models under `Peddler::APIs`.
- `status.success?`, `code`, `headers["Name"]`, `charset` and `to_s` on a response.
- Raising `Peddler::Error` on 4xx and 5xx, with `message` and `response`.
- The 4 document helpers, with their arguments: `download_report_document`, `upload_feed_document`, `download_result_feed_document` and `download_query_document`. They are on `client.reports`, `client.feeds` and `client.data_kiosk`. An ID of `"."` or `".."`, or an empty one, raises `ArgumentError` that names the argument, before any request.
- `Peddler::Marketplace`, `Peddler::Endpoint` and `Peddler::Money`.
- The typed parsers under `Peddler::Notifications`, `Peddler::Reports`, `Peddler::Feeds` and `Peddler::DataKiosk`.

```ruby
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token)

response = client.catalog_items.get_catalog_item("B08N5WRWNW", Peddler::Marketplace.id("UK"), included_data: "summaries,images")
response.status.success?  # => true
response.parse.asin       # => "B08N5WRWNW"
response.dig("asin")      # => "B08N5WRWNW"

report = client.reports.download_report_document(report_document_id)
report.to_s
```

### Argument forms

v5 sent whatever it was given. v6 sends the same request for every form that made sense, and raises `ArgumentError` for the rest, before anything is sent. The error names the argument and never shows its value.

| What you pass | v5 sent | v6 |
| --- | --- | --- |
| A String for a list: `get_catalog_item("B0X", "ATVPDKIKX0DER")` | `marketplaceIds=ATVPDKIKX0DER` | the same |
| A String of several items: `included_data: "attributes,issues"` | `includedData=attributes%2Cissues` | the same |
| A list of `Peddler::Marketplace` objects | their IDs | the same |
| `nil` for an optional argument | nothing | the same |
| A Hash or an Array for a body | its JSON | the same |
| A String that holds JSON for a body | the String | the same JSON, once |
| A number, a Symbol or a Date for a String: `get_order(12345)` | its text, `/orders/v0/orders/12345` | the same |
| A numeric String for a number: `page_size: "20"` | `pageSize=20` | the same |
| `"true"` or `"false"` for a boolean: `details: "true"` | `details=true` | the same |
| `nil` for a required argument: `get_order(nil)` | a request without it | `order_id is required` |
| An empty String at the end of a path: `get_order("")` | `/orders/v0/orders/` | `order_id must not be empty` |
| `"."` or `".."` anywhere in a path: `get_order("..")` | `/orders/v0/orders/..` | `order_id must not be . or ..` |
| A String that is not JSON for a body | the String | `body must be JSON` |
| Other text, or a Float, for an integer: `page_size: "many"` | `pageSize=many` | `page_size must be an Integer` |
| Other text for a boolean: `details: "yes"` | `details=yes` | `details must be true or false` |
| A Hash for a String: `get_order({ a: 1 })` | its inspect text | `order_id must be a String` |
| An Array inside a list: `[["ATVPDKIKX0DER"]]` | the items, flattened | `marketplace_ids must be an Array of Strings` |
| An object whose `to_s` is an inspect form, such as `#<Object>` or `#<struct ...>` | that text | `order_id must be a String`, or `marketplace_ids must be an Array of Strings` in a list |
| A String that is not valid UTF-8: `get_order("caf\xE9")` | its bytes, `/orders/v0/orders/caf%E9` | `order_id must be valid UTF-8` |
| A body that holds such a String, or a number that is not finite | `JSON::GeneratorError` | `body must be JSON: Strings of valid UTF-8 and finite numbers` |

### Edge differences

- A required argument given as `nil`, and the other forms in the lower half of the table above, raise `ArgumentError` where v5 sent a request.
- Any status outside 2xx raises `Peddler::Error`, from an API call and from a signed URL in the document helpers. v5 raised from 400 up and returned a 3xx as a response.
- The document helpers allow 600 seconds for a call and then raise `Peddler::DocumentTimeoutError`. v5 had no limit. For a longer transfer, use `client.open_report_document(id, timeout:)` and its siblings, described in the [README](README.md#documents-and-workflows).
- `download_report_document` returns the report decompressed when Amazon compressed it. Remove your own `Zlib::GzipReader`.
- `response.status` behaves as the Integer it wraps (`status == 200`, `status >= 400`, `case status when 200..299`), but it is not an instance of `Integer`. Use `response.code` where you need one. `status.to_s` is `"200"`, not `"200 OK"`, and `status.to_sym`, `status.ok?` and the other named predicates are gone.
- `response.headers.to_h` and `headers.each` give header names in lowercase. `headers["Name"]` finds a header whatever its case. `headers.get` and `headers.keys` are gone. `headers.include?(name)` no longer looks a name up and returns `false`: use `headers[name]`.
- `response.body` is a String. The other readers of the `http` gem's response, such as `content_type`, `mime_type`, `uri` and `request`, are gone. `Response#parsable?` is gone too.
- `error.response` is a `Peddler::Response`. It was the `http` gem's response.
- An HTTP error whose body carries no message has the message `request failed with status 500`, with its status. v5 used the status line.
- A signed URL that rejects a transfer raises a plain `Peddler::Error` with its `status`. Its `code` is `nil` and its XML reply is in `error.response.body`. v5 raised a class named after the XML code, such as `Peddler::Errors::AccessDenied`.
- The client has no readers for `access_token`, `retries`, `endpoint` or `base_url`.
- Fulfillment Inbound 2024-03-20 `list_prep_details` and `list_item_compliance_details` send `mskus` as a repeated parameter, as Amazon specifies. v5 joined the values with commas.

### Dependency changes

- The `http` and `nokogiri` gems are no longer dependencies. If your application used either through Peddler, add it to your Gemfile.
- `bigdecimal` and `rb_sys` are new dependencies.
- Peddler includes a native extension. Precompiled gems cover macOS and glibc Linux on Ruby 3.3, 3.4 and 4.0. Other platforms compile it during installation and need a Rust toolchain. See the [README](README.md#native-extension).

### New in v6

These need no change to existing code. The [README](README.md#usage) describes each.

- `*_pages` methods that enumerate the pages of an operation
- `wait_for_report`, `wait_for_feed` and `wait_for_query`
- Streaming downloads with `open_report_document`, `open_feed_document`, `open_query_document` and `download_document`, read as TSV, JSON Lines, JSON or bytes
- `create_and_upload_feed_document` and `upload_document`
- `lwa.token_source`, a token source that refreshes in the process
- `base_url:` in place of `region:`, to point a client at a local mock or a proxy
- Pattern matching on errors, by `status` and `code`
- `client.request`, the call for an endpoint Peddler has no method for yet

## From v4.x to v5.0

### Breaking Changes

#### 1. Error Handling

All HTTP errors (4xx and 5xx) now raise `Peddler::Error` exceptions instead of returning response objects.

**Before (v4.x):**
```ruby
# 5xx errors returned response objects
response = api.get_orders(marketplaceIds: ["ATVPDKIKX0DER"])
if response.status >= 500
  # Handle error
end

# Or opt-in to v5 behavior
Peddler.configure do |config|
  config.raise_on_server_errors = true
end
```

**After (v5.0):**
```ruby
# All errors now raise exceptions
begin
  response = api.get_orders(marketplaceIds: ["ATVPDKIKX0DER"])
rescue Peddler::Error => e
  # Handle error: e.status, e.response
end
```

#### 2. Typed Response API

The `.parse` method now always returns typed responses. Use `.to_h` for raw Hash access.

**Before (v4.x):**
```ruby
# Using .typed helper for type-safe responses
response = api.get_catalog_item(asin: "B08N5WRWNW")
item = response.typed  # Returns typed Structure object
```

**After (v5.0):**
```ruby
# .parse always returns typed responses
response = api.get_catalog_item(asin: "B08N5WRWNW")
item = response.parse  # Returns typed Structure object

# Use .to_h for raw Hash
hash = response.to_h
```

##### If You Weren't Using Typed Responses

If you were using Peddler v4 without the `.typed` method, you were working exclusively with Hash objects. The `.parse` method returned a Hash by default in v4.x. In v5, to maintain the same Hash-based behavior:

**v4 code (Hash-based):**
```ruby
response = api.get_catalog_item(asin: "B08N5WRWNW")
item = response.parse  # Hash in v4
title = item["summaries"].first["itemName"]
```

**v5 equivalent (Hash-based):**
```ruby
response = api.get_catalog_item(asin: "B08N5WRWNW")
item = response.to_h  # Hash - same behavior as v4's parse
title = item["summaries"].first["itemName"]
```

**v5 with typed responses (recommended):**
```ruby
response = api.get_catalog_item(asin: "B08N5WRWNW")
item = response.parse  # Typed Structure object
title = item.summaries.first.item_name  # Type-safe attribute access
```

**Note:** Before v4.6.0, typed responses didn't exist. Both `.parse` and `.to_h` returned Hashes and were interchangeable. If you're upgrading from those earlier versions, simply use `.to_h` instead of `.parse` to maintain the same Hash-based behavior, or embrace `.parse` for type-safe responses.

#### 3. LWA Token API

The `Token` class has been renamed to `LWA` and now returns typed responses.

**Before (v4.x and v5.0.0.pre.1):**
```ruby
# Class was named Token
payload = Peddler::Token.request(
  client_id: "YOUR_LWA_CLIENT_ID",
  client_secret: "YOUR_LWA_CLIENT_SECRET",
  grant_type: "refresh_token",
  refresh_token: "YOUR_REFRESH_TOKEN",
)

# Access token via hash keys
access_token = payload.parse["access_token"]
```

**After (v5.0):**
```ruby
# Class renamed to LWA
payload = Peddler::LWA.request(
  client_id: "YOUR_LWA_CLIENT_ID",
  client_secret: "YOUR_LWA_CLIENT_SECRET",
  grant_type: "refresh_token",
  refresh_token: "YOUR_REFRESH_TOKEN",
)

# Access token via typed attributes
access_token = payload.parse.access_token
```

#### 4. Type Namespace Changes

API response types have been moved from `Peddler::Types::*` to their respective API namespaces.

**Before (v4.x):**
```ruby
# Types were under Peddler::Types
order = Peddler::Types::OrdersV0::Order.new(...)
item = Peddler::Types::CatalogItems20220401::Item.new(...)
```

**After (v5.0):**
```ruby
# Types nested under their API
order = Peddler::APIs::OrdersV0::Order.new(...)
item = Peddler::APIs::CatalogItems20220401::Item.new(...)
```

This change improves discoverability and reduces namespace clutter. Types are now colocated with their respective APIs.

### Removed APIs

The following deprecated methods and configurations have been removed:

- `Response.decorate` method (use `Response.new` instead)
- `raise_on_server_errors` configuration option (no longer needed - all errors raise)
- `API#through` alias (use `API#via` instead)
- `Token::Error` class (replaced by `Peddler::Error`)
- `.typed` helpers (use `.parse` directly)

### New Features

#### Notification Parsing

Peddler now provides type-safe parsing for SP-API notifications using the Structure gem.

```ruby
# Parse notification from SQS message
notification_json = JSON.parse(sqs_message.body)
notification = Peddler::Notifications::AnyOfferChanged.parse(notification_json)

# Type-safe access to notification data
notification.notification_version  # => "1.0"
notification.notification_type     # => "ANY_OFFER_CHANGED"
notification.payload.offers.each do |offer|
  puts "Seller: #{offer.seller_id}"
  puts "Price: #{offer.listing_price.amount} #{offer.listing_price.currency_code}"
  puts "Shipping: #{offer.shipping.amount}" if offer.shipping
end
```

Available notification types include:
- `AnyOfferChanged`
- `FeedProcessingFinished`
- `FulfillmentOrderStatus`
- `ItemProductTypeChange`
- And 20+ more...

#### Report Parsing

Type-safe parsing for JSON-based SP-API reports.

```ruby
# Request a report
api = Peddler.reports.new(aws_region, access_token)
report_response = api.create_report({
  "reportType" => "GET_VENDOR_REAL_TIME_INVENTORY_REPORT",
  "marketplaceIds" => [Marketplace.id("US")]
})

# Wait for report to be ready, then download
report_id = report_response.dig("reportId")
# ... poll until DONE ...
document_id = api.get_report(report_id).dig("reportDocumentId")

# Download and parse with type safety
document = api.get_report_document(document_id)
report_json = HTTP.get(document.dig("url")).parse(:json)

# Use typed data classes
report = Peddler::Reports::VendorRealTimeInventory::Report.new(report_json)
report.report_data.each do |data|
  puts "ASIN: #{data.asin}"
  puts "Available: #{data.highly_available_inventory}"
end
```

Supported reports include:
- Vendor Real-Time Inventory
- Seller Sales and Traffic
- Account Health
- Vendor Forecasting
- And 20+ more...

#### Feed Parsing

Type-safe parsing for feed processing reports.

```ruby
# After feed processing completes
result_document = api.get_feed_document(result_feed_document_id)
result_json = JSON.parse(HTTP.get(result_document.dig("url")).to_s)

# Parse with type safety
report = Peddler::Feeds::ListingsFeedProcessingReportSchema.parse(result_json)

# Access structured error data
puts "Processed: #{report.summary.messages_processed}"
puts "Accepted: #{report.summary.messages_accepted}"
puts "Errors: #{report.summary.messages_with_error}"

report.issues.each do |issue|
  puts "Message #{issue.message_id}: #{issue.message}"
  puts "Severity: #{issue.severity}"
  puts "Code: #{issue.code}" if issue.code
end
```

#### Zeitwerk Autoloading

Peddler now uses Zeitwerk for autoloading, significantly improving startup time. Only the APIs you use are loaded into memory.

```ruby
# Before: All 61 APIs loaded at require time
require "peddler"

# After: APIs loaded on-demand
require "peddler"
api = Peddler.orders.new(...)  # Only OrdersV0 loaded here
```

No code changes required - this optimization is transparent to your application.

### Dependency Changes

- Nokogiri is now a required dependency (previously optional)
- Zeitwerk is now a required dependency (new)
