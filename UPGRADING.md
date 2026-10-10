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

`client.orders` is the latest version of an API, as `Peddler.orders` was, and `client.orders_v0` a pinned one. `Peddler.new` is short for `Peddler::Client.new`.

1 of them moved since 5.5.0. `fulfillment_outbound` is now Fulfillment Outbound 2026-07-04, which has `create_order` where 2020-07-01 had `create_fulfillment_order`. To stay on the older version, call `client.fulfillment_outbound_2020_07_01`.

`Peddler.<api>` and `Peddler::APIs::OrdersV0.new` are gone. `Peddler::APIs::OrdersV0` is now a module that holds the typed models, so `Peddler::APIs::OrdersV0::Order` still works.

The `http:` option is gone, with the `http` gem. A client takes `timeout:`, the seconds each attempt of a call may take. The default is 30, where v5 had none.

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

After `fork`, create clients, and a `Peddler::LWA`, in the child process. One created before the fork raises `Peddler::ForkError` there, and the message says which to create.

Peddler now sends its requests through the proxy that `HTTPS_PROXY` or `ALL_PROXY` names in the environment, unless `NO_PROXY` lists the host. v5 ignored these variables. Unset them if a proxy must not see the calls.

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

`Peddler::LWA.new` reads `LWA_CLIENT_ID` and `LWA_CLIENT_SECRET` from the environment, or takes `client_id:` and `client_secret:`, as before. `Peddler::LWAToken` is now `Peddler::LWA::Tokens`, with the same `access_token`, `refresh_token`, `token_type`, `expires_in` and `scope`. Tokens with the same values are equal, as before.

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

The client still sends the token you give it and requests none itself. What is new is that the token may be a callable. Keep the cache you have, and the client asks it before every attempt of a call, a retry included.

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

#### 5. Retries

`rate_limit:` and `retries:` stay, and a call that passes them needs no change.

```ruby
client.orders_v0.get_orders(marketplace_ids, created_after: "2026-01-01T00:00:00Z", rate_limit: 0.5)
```

`rate_limit:` still sets the wait after a 429 and paces nothing. Its default is still the rate Amazon documents for the operation. Every operation takes it now, also one without a documented rate, where the default is `nil`. A value that is not a positive number raises `ArgumentError` before anything is sent. v5 checked nothing.

`retries:` waits as it did. After a 429 it waits 1 / rate seconds, doubling each time: 2, 4 and 8 seconds for an operation limited to 0.5 requests a second, and 60, 120 and 240 for one limited to 1 a minute. After a 5xx or a failed connection it waits up to 1 second, then 1 to 2, then 3 to 4. If the response has a `Retry-After` header, it waits as long as that asks instead. No wait has a ceiling.

It differs in 2 ways.

- After a 500, 502, 503 or 504, a failed connection or a timeout, v6 retries a GET only. v5 retried every method, which could submit a feed or an order twice. After a 429 both retry every method, since a throttled request was not processed.
- `timeout:` limits each attempt, and v5 had no limit by default. The waits between attempts are not counted, so a throttled call takes as long as it did in v5.

`retries:` takes 0 to 10.

#### 6. Tests

A suite keeps its helper as it is. Peddler's requests now leave through the native extension, but once WebMock is loaded Peddler loads an adapter of its own before the next one, so stubs, `assert_requested`, `WebMock.disable_net_connect!`, `WebMock.disable!` and VCR work as they did.

**Before (v5):**
```ruby
require "webmock/minitest"

stub_request(:get, "https://sellingpartnerapi-eu.amazon.com/orders/v0/orders/123-1234567-1234567")
  .to_return(body: JSON.generate(payload: { AmazonOrderId: "123-1234567-1234567" }))
api = Peddler.orders_v0.new("eu-west-1", "token")
```

**After (v6):**
```ruby
require "webmock/minitest"

stub_request(:get, "https://sellingpartnerapi-eu.amazon.com/orders/v0/orders/123-1234567-1234567")
  .to_return(body: JSON.generate(payload: { AmazonOrderId: "123-1234567-1234567" }))
client = Peddler::Client.new(region: "eu-west-1", access_token: "token")
```

A suite that passes `except:` to `WebMock.enable!` or `WebMock.disable!` before Peddler's first request adds 1 line, `require "peddler/webmock"`, before that call. An adapter that loads later can't see the call: after `WebMock.enable!(except: [:net_http])` the request is sent to Amazon.

A stubbed response is handled as one from Amazon is, so the changes above show in a test too.

- `to_timeout` raises `Peddler::TimeoutError`, or `Peddler::DocumentTimeoutError` for a signed URL.
- A stubbed status outside 2xx raises `Peddler::Error`. With `retries:` set, a stubbed 429 waits by the operation's rate, a minute for `get_orders`: give the stub a `Retry-After: 0` header, or the call a fast `rate_limit:`.
- A request without a stub raises `WebMock::NetConnectNotAllowedError`, as before. Its message shows the request with its headers, the access token among them.
- A document is not streamed while WebMock is enabled: an upload is read to its end before it is sent, and a download arrives whole.

Cassettes recorded with v5 replay, the token request in them too. 2 operations need more: `list_prep_details` and `list_item_compliance_details` of Fulfillment Inbound 2024-03-20 now repeat `mskus`, where the cassette holds 1 value with commas. WebMock keeps only the last value of a repeated parameter unless it is told otherwise. Match a URI by its values, and tell WebMock to keep them all.

```ruby
VCR.configure do |config|
  config.hook_into(:webmock)
  config.register_request_matcher(:uri_with_lists) do |recorded, sent|
    recorded, sent = [recorded, sent].map do |request|
      uri = URI(request.uri)
      pairs = URI.decode_www_form(uri.query.to_s).flat_map { |name, value| value.split(",").map { |item| [name, item] } }
      [uri.host, uri.path, pairs.sort]
    end
    recorded == sent
  end
  config.default_cassette_options = { match_requests_on: [:method, :uri_with_lists] }
end

WebMock::Config.instance.query_values_notation = :flat_array
```

The notation is for the whole suite: set it before the first request. Under it `with(query: hash_including(...))` no longer matches, so give such a stub the whole query.

A test can also start a local server and point the client at it with `base_url:`. `Peddler::LWA` takes `lwa_endpoint:` in the same way.

```ruby
client = Peddler::Client.new(base_url: "http://127.0.0.1:#{port}", access_token: "token")
lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "http://127.0.0.1:#{port}/auth/o2/token")
```

Plain `http` is accepted for `localhost` and loopback addresses only. If the environment sets `HTTP_PROXY` or `ALL_PROXY`, add `NO_PROXY=localhost,127.0.0.1`, or the test's requests go to the proxy.

A test that needs no HTTP can stub the method it calls and return a `Peddler::Response`, which v6 builds from a status, the headers as pairs and a body: `Peddler::Response.new(200, [["content-type", "application/json"]], "{}")`.

### What keeps working

- Method names and signatures. Required arguments are positional, in the same order, and optional ones are keywords with the same names.
- The forms an argument may take, listed under [Argument forms](#argument-forms): a String for a list, a String that holds JSON for a body, a number where a String is expected and a numeric String where a number is.
- A list of `Peddler::Marketplace` objects where a list of IDs goes, and any other object that converts itself with `to_str`. A single `Peddler::Marketplace` in place of its ID now works too, and so does one inside a request body.
- The documentation of every operation and API class, in the comments above them.
- `parse`, `to_h` and `dig` on a response, and the typed models under `Peddler::APIs`.
- `status.success?`, `code`, `headers["Name"]`, `headers.include?("Name")`, `charset` and `to_s` on a response. A response is still its text where a String is taken, as in `JSON.parse(response)`.
- Raising `Peddler::Error` on 4xx and 5xx, with `message` and `response`.
- The 4 document helpers, with their arguments: `download_report_document`, `upload_feed_document`, `download_result_feed_document` and `download_query_document`. They are on `client.reports`, `client.feeds` and `client.data_kiosk`. `upload_feed_document` still sends the length of a String, and of a source that answers `size`, such as a File or a StringIO. An ID of `"."` or `".."`, or an empty one, raises `ArgumentError` that names the argument, before any request.
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
| A `Peddler::Marketplace` alone: `get_catalog_item("B0X", marketplace)` | its inspect text | its ID |
| A `Peddler::Marketplace` inside a body, at any depth: `create_feed({ "marketplaceIds" => [marketplace] })` | its inspect text | its ID |
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
- A `Retry-After` header that is neither a number of seconds nor a date is ignored, and the retry waits as it would without one. v5 retried at once.
- The document helpers allow 600 seconds for a call. v5 had no limit. Past it, the transfer raises `Peddler::DocumentTimeoutError`. The request that looks a document up by its ID is a request like any other: it raises `Peddler::TimeoutError` when it takes longer than that, or than the client's `timeout:`. For a longer transfer, use `client.reports.open_report_document(id, timeout:)` and its siblings, described in the [README](README.md#documents-and-workflows).
- Given a document ID, `download_report_document` returns the report decompressed when Amazon compressed it. Remove your own `Zlib::GzipReader`. Given a URL, it decompresses only when the reply says `Content-Encoding: gzip`, so a report whose metadata says `GZIP` still arrives compressed.
- `response.status` behaves as the Integer it wraps (`status == 200`, `status >= 400`, `case status when 200..299`), but it is not an instance of `Integer`. Use `response.code` where you need one. `status.to_s` is `"200"`, not `"200 OK"`, and `status.to_sym`, `status.ok?` and the other named predicates are gone. In RBS, `status` is a `Peddler::Response::Status` where v5 declared an `Integer`: it compares as one, and `code` is the `Integer`.
- `response.headers.to_h` and `headers.each` give header names in lowercase. `headers["Name"]`, `headers.include?("Name")` and `headers.key?("Name")` find a header whatever its case. `headers.get` and `headers.keys` are gone.
- `response.body` is a String. The other readers of the `http` gem's response, such as `content_type`, `mime_type`, `uri` and `request`, are gone. `Response#parsable?` and `Response#parser` are gone too.
- `response.inspect` is the class and the status, `#<Peddler::Response 200>`. A body can hold a token.
- `Peddler::Response.new` takes a status, the headers as pairs and a body: `Peddler::Response.new(200, [["content-type", "application/json"]], "{}")`. v5 wrapped a response of the `http` gem with `Response.new(http_response, parser:)` or `Response.wrap`, which is gone.
- `error.response` is a `Peddler::Response`. It was the `http` gem's response.
- An HTTP error whose body carries no message has the message `request failed with status 500`, with its status. v5 used the status line.
- A signed URL that rejects a transfer raises a plain `Peddler::Error` with its `status`. Its `code` is `nil` and its XML reply is in `error.response.body`. v5 raised a class named after the XML code, such as `Peddler::Errors::AccessDenied`.
- The client has no readers for `access_token`, `retries`, `endpoint` or `base_url`.
- The modules under `Peddler::Helpers` are gone. Their methods are on the API views, where you called them. `Peddler::API::TRANSIENT_STATUSES` is gone with `Peddler::API`.
- `Peddler::REGIONS` is now `Peddler::Endpoint::REGIONS`. It and `Peddler::MARKETPLACE_IDS` are frozen.
- `Peddler::Acronyms` has no instance methods any more. Call `Peddler::Acronyms.apply` and `Peddler::Acronyms.values`.
- `require "peddler"` loads the client, responses, errors, `Peddler::LWA`, marketplaces and `Peddler::Money`. v5 loaded them on first use, as the typed models still are.
- The RBS signatures of the client and the operations are in `sig/inline`, written from inline RBS in the Ruby files, and `sig/peddler.rbs` is gone. A type checker finds them under `sig/` as before. `Marketplace#to_s` left them: the class never defined it.
- Fulfillment Inbound 2024-03-20 `list_prep_details` and `list_item_compliance_details` send `mskus` as a repeated parameter, as Amazon specifies. v5 joined the values with commas.

### Dependency changes

- The `http` and `nokogiri` gems are no longer dependencies. If your application used either through Peddler, add it to your Gemfile.
- `bigdecimal` and `rb_sys` are new dependencies.
- Peddler includes a native extension. Precompiled gems cover macOS and glibc Linux on Ruby 3.3, 3.4 and 4.0. Other platforms compile it during installation and need a Rust toolchain. See the [README](README.md#native-extension).

### New in v6

These need no change to existing code. The [README](README.md#usage) describes each.

- `*_pages` methods that enumerate the pages of an operation
- `wait_for_report`, `wait_for_feed` and `wait_for_query`, on `client.reports`, `client.feeds` and `client.data_kiosk`, beside v5's helpers
- Streaming downloads with `open_report_document`, `open_feed_document` and `open_query_document` on the same 3, and `client.download_document` for a signed URL, read as TSV, JSON Lines, JSON or bytes
- `client.feeds.create_and_upload_feed_document`, and `client.upload_document` for a signed URL
- `lwa.token_source`, a token source that refreshes in the process
- `base_url:` in place of `region:`, to point a client at a local mock or a proxy
- Pattern matching on errors, by `status` and `code`
- `client.request`, the call for an endpoint Peddler has no method for yet
- Ractors: a client built in a Ractor other than the main one works there ([#279](https://github.com/lineofflight/peddler/issues/279)). `Peddler.eager_load!` loads the typed models ahead, which Ruby 3.3 needs
- Amazon's description of each parameter in the RBS signatures of the operations, which an editor shows on hover

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
