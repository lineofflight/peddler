# Peddler for Ruby

Peddler is a Ruby gem for the [Amazon Selling Partner API (SP-API)][api-docs]. It is generated from Amazon's OpenAPI models, covers all SP-API endpoints, reports, notifications and feeds, and runs on a Rust core that it ships as a native extension.

Add to your Gemfile.

```ruby
gem "peddler"
```

This example reads your [LWA credentials][view-credentials] from `LWA_CLIENT_ID` and `LWA_CLIENT_SECRET` and a seller's refresh token from `REFRESH_TOKEN`, then lists the seller's marketplaces.

```ruby
require "peddler"

lwa = Peddler::LWA.new
access_token = lwa.refresh(refresh_token: ENV.fetch("REFRESH_TOKEN")).access_token
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token)

response = client.sellers.get_marketplace_participations
response.parse.payload.each { |participation| puts participation.marketplace.name }
```

The [README](README.md) introduces the gem and the Rust crate. Coming from Peddler 5? See [UPGRADING.md](UPGRADING.md).

## Installation

Add to your Gemfile.

```ruby
gem "peddler"
```

Peddler needs Ruby 3.3 or later.

### Native extension

Bundler installs a precompiled gem where one exists:

| Platform | Gem platform |
| --- | --- |
| macOS, Apple silicon | `arm64-darwin` |
| macOS, Intel | `x86_64-darwin` |
| Linux with glibc, ARM | `aarch64-linux-gnu` |
| Linux with glibc, x86 | `x86_64-linux-gnu` |
| Linux with glibc, 32-bit ARMv7 or later, hard float | `arm-linux-gnu` |
| Linux with musl, such as Alpine, ARM | `aarch64-linux-musl` |
| Linux with musl, x86 | `x86_64-linux-musl` |
| Linux with musl, 32-bit ARMv7 or later, hard float | `arm-linux-musl` |
| Windows, x64, with RubyInstaller's Ruby | `x64-mingw-ucrt` |

Each carries a build for Ruby 3.3, 3.4 and 4.0 and needs no compiler. The musl gems need `libgcc_s.so.1`: on Alpine, the `libgcc` package, which the official Ruby images have.

ARMv6 hosts, such as a Raspberry Pi 1 or Zero, and soft-float hosts get the 32-bit ARM gem from RubyGems too, but it doesn't run there: compile from source with `--platform ruby`, as below.

On any other platform, Bundler installs the source gem and compiles the extension during installation. That needs:

- Rust 1.88 or later with `cargo` on `PATH` (see [rustup](https://rustup.rs)); Peddler is built and tested with the current stable release
- the Ruby headers (`ruby-dev` or `ruby-devel` on Linux)
- `clang` and `libclang`
- network access to crates.io

On Windows, compiling needs Rust's GNU toolchain, `stable-x86_64-pc-windows-gnu`, and the MSYS2 toolchain that `ridk install` sets up: RubyInstaller builds Ruby with MinGW.

To compile from source where a precompiled gem exists, run `gem install peddler --platform ruby` or `bundle config set force_ruby_platform true`.

### Licenses

Peddler is released under the [MIT License](LICENSE).

A precompiled gem has Rust crates linked into its extension, each under a license of its own: MIT, Apache-2.0, BSD-3-Clause, ISC or Unicode-3.0. `THIRD_PARTY_LICENSES.html` at the root of each precompiled gem lists every one of them with its version and the text of its license, and has the notices of the Rust standard library. The Windows gem also links the MinGW-w64 runtime and winpthreads, and has their notices as well. `gem contents peddler` shows where it is.

The source gem has no such file. It compiles the crates on your machine, where Cargo downloads each with its license.

### Agent skills

Install the skills for agents:

```shell
# Install both skills
npx skills add lineofflight/peddler

# Or install individually
npx skills add lineofflight/peddler -s building-with-peddler
npx skills add lineofflight/peddler -s amazon-sp-api
```

- `building-with-peddler`: Ruby integration, tokens, retries, pagination, documents, tests, and Ractors.
- `amazon-sp-api`: Language-agnostic OpenAPI spec research, issue hunting, and discussions.

## Authorization

Before using Peddler, you must [register as a developer][register-as-developer], [register your application][register-application], and [obtain your Login with Amazon (LWA) credentials][view-credentials]; Amazon's [official SP-API code samples][api-samples] can help you get started.

Set your LWA credentials in your environment.

```shell
export LWA_CLIENT_ID=<YOUR_CLIENT_ID>
export LWA_CLIENT_SECRET=<YOUR_CLIENT_SECRET>
```

A seller or vendor [provides you a refresh token][authorization] to access their data on Amazon. If they authorize your application on your website, exchange the authorization code for one. Pass the `redirect_uri` of your authorization request.

```ruby
lwa = Peddler::LWA.new
tokens = lwa.exchange_authorization_code(
  code: "<AUTHORIZATION_CODE>",
  redirect_uri: "https://example.com/callback",
)
refresh_token = tokens.refresh_token
```

Use the refresh token to request temporary access tokens. An access token is valid for 1 hour.

```ruby
tokens = lwa.refresh(refresh_token: refresh_token)
tokens.access_token # => "Atza|..."
tokens.expires_in   # => 3600
```

The client sends the access token you give it. It never requests, refreshes or caches a token itself, so your application decides where tokens live.

Most applications run several processes. Give the client a callable that reads the token from a cache your processes share and requests a new one when the cache is empty.

```ruby
client = Peddler.new(
  region: "eu-west-1",
  access_token: -> {
    Rails.cache.fetch("lwa/#{seller.id}", expires_in: 50.minutes) do
      lwa.refresh(refresh_token: seller.refresh_token).access_token
    end
  },
)
```

`Peddler.new` is short for `Peddler::Client.new`.

The client calls it before every attempt of a call, on the thread that makes the call: each operation, each page of a `*_pages` enumerator, each poll of a `wait_for_*` method, and each [retry](#rate-limiting) of those. So a retry minutes later sends a fresh token. Keep it thread-safe.

The time it takes counts against `timeout:`. The timeout can't cut a source short, so one slower than it is waited for, and the attempt has then timed out.

In a single process, `token_source` does the same without a cache of your own. It keeps one access token in memory, requests the next one 60 seconds before the old one expires and makes one request at a time, however many threads ask.

```ruby
source = lwa.token_source(refresh_token: seller.refresh_token)
client = Peddler::Client.new(region: "eu-west-1", access_token: source)
```

Each process that builds a source refreshes for itself. Use a callable around a shared cache when processes should share a token.

A fixed token also works, for a script or a console session.

```ruby
access_token = lwa.refresh(refresh_token: seller.refresh_token).access_token
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token)
```

Similarly, you can request a token for [grantless operations][grantless-operations], or build a source for one.

```ruby
access_token = lwa.client_credentials(scope: "sellingpartnerapi::notifications").access_token
source = lwa.token_source(scope: "sellingpartnerapi::notifications")
```

In place of environment variables, you can pass your credentials directly.

```ruby
lwa = Peddler::LWA.new(
  client_id: "<YOUR_CLIENT_ID>",
  client_secret: "<YOUR_CLIENT_SECRET>",
)
```

`Peddler::LWA.new` also takes `timeout:`, the number of seconds each of its requests may take, 30 by default.

`Peddler::LWA` makes one request per call and keeps nothing. The tokens it returns have `access_token`, `refresh_token`, `token_type`, `expires_in` and `scope`.

If Amazon rejects a request, it raises `Peddler::AuthenticationError` with the HTTP `status` and Amazon's `code`, such as `"invalid_grant"`. A blank argument raises `ArgumentError` before anything is sent, such as `refresh_token must be a UTF-8 String that is not blank`.

## The client

A single client reaches every API. Create it with the AWS region of the seller and an access token.

```ruby
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token)
```

The region is `us-east-1` for North America, `eu-west-1` for Europe or `us-west-2` for the Far East. `Peddler::Marketplace.find("UK").endpoint.aws_region` returns the region of a marketplace.

Each API is a method on the client. Its operations take required arguments in order and optional ones as keywords.

```ruby
response = client.orders_v0.get_orders(
  Peddler::Marketplace.ids("UK"),
  created_after: "2026-01-01T00:00:00Z",
  order_statuses: ["Unshipped", "PartiallyShipped"],
)
```

Where a marketplace ID goes, a `Peddler::Marketplace` works too: `Peddler::Marketplace.find("UK")` in place of its ID. That holds for an argument and anywhere inside a request body, in an operation and in `request`. A String must be valid UTF-8, or the call raises `ArgumentError` that names the argument, such as `order_id must be valid UTF-8`.

A request body is a Hash with the field names Amazon documents. A String that holds JSON also works.

```ruby
response = client.reports.create_report({
  "reportType" => "GET_MERCHANT_LISTINGS_ALL_DATA",
  "marketplaceIds" => Peddler::Marketplace.ids("UK"),
})
```

Every operation is documented where it is defined, in [lib/peddler/native/apis.rb](lib/peddler/native/apis.rb): what it does, each argument, and whether it can run in the sandbox. The [documentation site](https://lineofflight.dev/peddler/) shows the same, with each method's signature.

The gem ships RBS signatures under `sig/`, for Steep and for an editor that reads RBS. Those of the operations carry Amazon's description of each argument, so the editor shows it on hover.

For an endpoint Peddler has no method for yet, call `request` with the HTTP method and the path. It sends the client's token and keeps its timeout and retries. Its response has no typed model, so `parse` returns the Hash.

```ruby
response = client.request(
  "GET",
  "/orders/v0/orders",
  params: { MarketplaceIds: Peddler::Marketplace.ids("UK", "DE"), CreatedAfter: "2026-01-01T00:00:00Z" },
)
orders = response.dig("payload", "Orders")
```

A parameter value takes what an operation's argument takes: a String, a number, a boolean, a `Peddler::Marketplace`, or an Array of them, which is joined with commas. A method or a path that is not a String raises `ArgumentError`, such as `path must be a String`.

The client takes two options. `timeout:` is the number of seconds each attempt of a call may take, 30 by default. Without `retries:` a call is one attempt. `retries:` is described under [Rate limiting](#rate-limiting). An option that breaks its rule raises `ArgumentError` that names it, such as `retries must be an Integer between 0 and 10`.

A call ends early only when Ruby raises in its thread: `Timeout.timeout`, `Thread#raise`, `Thread#kill` or an interrupt. Peddler then cancels the request and closes its connection, or ends the wait before a retry. A signal your program traps and `Thread#wakeup` raise nothing, so the call goes on and a wait is no shorter.

Requests go through the proxy that `HTTPS_PROXY` or `ALL_PROXY` names in the environment, unless `NO_PROXY` lists the host.

To call with another token, for another seller or with a [restricted data token](#restricted-data-tokens-rdt-and-pii), take a view of the client. `with_access_token` accepts what `access_token:` accepts.

```ruby
other = client.with_access_token(other_seller.access_token)
other.sellers.get_marketplace_participations
```

All clients and views in a process share one connection pool, so creating a client for each job or request is cheap.

After `fork`, create your clients in the child process. A client, a `Peddler::LWA` or a token source created before the fork raises `Peddler::ForkError` in the child, and the message says which to create again. With a preloading server such as Puma or Unicorn, create clients when you need them, not at boot.

## Restricted Data Tokens (RDT) and PII

Some operations are restricted because they return Personally Identifiable Information (PII), such as a buyer's name and shipping address. To call one, exchange your access token for a Restricted Data Token (RDT) scoped to the specific resources you need, then send the RDT in place of the access token.

```ruby
response = client.tokens.create_restricted_data_token({
  "restrictedResources" => [
    {
      "method" => "GET",
      "path" => "/orders/v0/orders/123-1234567-1234567/address",
    },
  ],
})
restricted_data_token = response.parse.restricted_data_token
```

Use the RDT exactly where you would normally pass the access token.

```ruby
restricted = client.with_access_token(restricted_data_token)
address = restricted.orders_v0.get_order_address("123-1234567-1234567").parse.payload.shipping_address
```

For the Orders API, also specify which `dataElements` you need (`buyerInfo`, `shippingAddress`, or `buyerTaxInformation`).

```ruby
response = client.tokens.create_restricted_data_token({
  "restrictedResources" => [
    {
      "method" => "GET",
      "path" => "/orders/v0/orders",
      "dataElements" => ["buyerInfo", "shippingAddress"],
    },
  ],
})
restricted_data_token = response.parse.restricted_data_token
```

An RDT is valid for 1 hour. Like access tokens, cache and reuse it across calls. See the [Tokens API Use Case Guide][tokens-guide] for the full list of restricted operations.

## Rate limiting

Amazon's SP-API imposes [rate limits][rate-limits] on operations. Peddler does not pace your calls: a client cannot know how many processes share a seller's quota. Space calls in your application, for example in your job queue. Amazon returns the limit of most operations in the `x-amzn-RateLimit-Limit` response header.

Provide an optional `retries:` argument when creating a client to specify retry attempts if throttled. Default is 0 (no retries). The most is 10.

```ruby
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token, retries: 3)
client.orders_v0.get_orders(Peddler::Marketplace.ids("UK"), created_after: "2026-01-01T00:00:00Z")
```

Peddler retries a request that Amazon answers with 429, whatever its method: a throttled request was not processed.

It also retries a GET that Amazon answers with 500, 502, 503 or 504, that got no response, or that ran past `timeout:`. Through `request`, it retries a HEAD and an OPTIONS too. It never retries another method after these, since Amazon may have processed the request, and a second one could submit a feed or an order twice.

After a 429, Peddler waits by the rate Amazon documents for the operation: 1 / rate seconds before the first retry, twice that before the second, and so on, plus up to 0.1 seconds. An operation limited to 0.5 requests a second waits 2, 4 and 8 seconds. One limited to 1 request a minute waits 60, 120 and 240. In the sandbox the first wait is 0.2 seconds, whatever the rate.

The rates come from Amazon's API models. Peddler doesn't read `x-amzn-RateLimit-Limit`. If Amazon gave your account another limit, override the default value by passing a `rate_limit:` parameter when calling an operation.

```ruby
client.orders_v0.get_orders(
  Peddler::Marketplace.ids("UK"),
  created_after: "2026-01-01T00:00:00Z",
  rate_limit: 0.5,
)
```

`rate_limit:` is in requests per second. Every operation and every `*_pages` method takes it. It sets the wait after a 429 and nothing else: no call is paced. `nil` is no rate, which is the default where Amazon documents none. A value that is not a positive number raises `ArgumentError` before anything is sent: `rate_limit must be a positive number of requests per second`.

After a 5xx, a failed connection or a timeout, Peddler waits up to 1 second, then 1 to 2, then 3 to 4, and so on. So does a 429 of a call without a rate, and of a call through `request`.

If the response has a `Retry-After` header, Peddler waits as long as it asks instead.

No wait has a ceiling. An operation limited to 1 request a minute waits 512 minutes before its tenth retry. The slowest, `search_orders` of Orders 2026-01-01, waits 179, 357 and 714 seconds before its first three.

`timeout:` limits each attempt. The waits between attempts are not counted, so a call can take far longer than `timeout:`: 7 minutes for 3 retries at 1 request a minute, and 17 hours for 10. Choose `retries:` by how long a call may take, or wrap the call in `Timeout.timeout`, which ends a wait too.

A token given as a String is sent on every attempt: give a call that may wait for minutes one that outlives it, or a token source.

When Peddler stops retrying, the last response raises `Peddler::Error` like any other. If the last attempt got no response, it raises `Peddler::TransportError` or `Peddler::TimeoutError`.

## Typed Responses

Peddler provides typed response parsing using the [Structure gem](https://github.com/hakanensari/structure), offering runtime type checking and better IDE support. Types are based on Ruby's [Data class](https://docs.ruby-lang.org/en/4.0/Data.html) and are lazy-loaded.

```ruby
response = client.orders_v0.get_orders(Peddler::Marketplace.ids("US"), created_after: "2026-01-01T00:00:00Z")

# Use .parse to get typed Data objects
orders = response.parse.payload.orders  # Returns array of Order Data objects
order = orders.first

# Type-safe attribute access
order.amazon_order_id           # => "123-4567890-1234567"
order.order_status              # => "Shipped"
order.prime?                    # => true
order.order_total               # => Money object (automatic coercion)
order.order_total.amount        # => "99.99"
order.order_total.currency_code # => "USD"
order.order_total.to_d          # => 0.9999e2
```

### Hash Access

If you prefer working with plain hashes instead of typed Data objects:

```ruby
# Use .to_h to get raw Hash
orders = response.to_h["payload"]["Orders"]

# Or use .dig directly (delegates to .to_h)
orders = response.dig("payload", "Orders")
```

### Status, headers and body

```ruby
response.status.success?                 # => true
response.code                            # => 200
response.headers["x-amzn-RequestId"]     # => "a1b2c3d4-..."
response.headers["x-amzn-RateLimit-Limit"] # => "0.0167"
response.headers.include?("x-amzn-RequestId") # => true
response.body                            # the bytes as they arrived
response.to_s                            # the body as text, in the charset Amazon declares
response.inspect                         # => "#<Peddler::Response 200>"
```

A response is its text wherever a String is taken, as in `JSON.parse(response)`. `inspect` shows the class and the status only, since a body can hold a token.

## Error Handling

Every response outside 2xx raises `Peddler::Error`: a 4xx, a 5xx, and a 3xx too, since Peddler follows no redirect. Errors expose Amazon's `message`, the HTTP `status`, Amazon's error `code`, the `request_id` and the underlying `response`, and support pattern matching on `status` and `code`:

```ruby
begin
  response = client.orders_v0.get_orders(Peddler::Marketplace.ids("UK"), created_after: "2026-01-01T00:00:00Z")
rescue Peddler::Error => e
  case e
  in status: 429
    backoff_and_retry
  in code: "InvalidInput"
    fix_the_request
  in status: 500..599
    retry_later
  else
    raise
  end
end
```

There is one error class for every HTTP error. Tell them apart by `code`, such as `"QuotaExceeded"`, `"InvalidInput"` or `"Unauthorized"`.

A failure that is not an HTTP error response from the API has a class of its own. None of these descends from `Peddler::Error`.

| Error | Raised when |
| --- | --- |
| `Peddler::TransportError` | A request got no response: DNS, connection or TLS failed. |
| `Peddler::TimeoutError` | The last attempt of a call ran past its `timeout:`. So did a token request, or the request that looks a document up or creates one. A `Peddler::TransportError`. |
| `Peddler::AuthenticationError` | Login with Amazon rejected a token request. Has `status` and `code`, and matches patterns on them. |
| `Peddler::PaginationError` | A `*_pages` enumerator cannot continue. Has `reason`. |
| `Peddler::DocumentError` | A document transfer failed, or a document is not what the reader expects. |
| `Peddler::DocumentTimeoutError` | A document transfer ran past its `timeout:`. A `Peddler::DocumentError`. |
| `Peddler::WorkflowError` | A document's metadata is unusable, or a report, feed or query has a status Peddler doesn't know. |
| `Peddler::WorkflowTimeoutError` | A `wait_for_*` call ran past its own `timeout:`, and nothing else. A `Peddler::WorkflowError`. |
| `Peddler::ForkError` | A client, a `Peddler::LWA` or a token source created before `fork` is used in the child. |
| `ArgumentError` | An option or argument breaks its rule. The message names it, such as `order_id is required` or `page_size must be an Integer`. Nothing was sent. |

## Sandbox and custom endpoints

Get a view of a client on Amazon's hosted sandbox with `sandbox`:

```ruby
sandbox = client.sandbox
sandbox.orders_v0.get_orders(Peddler::Marketplace.ids("US"), created_after: "TEST_CASE_200")
```

`sandbox` returns a new client and leaves the one you call it on in production, so use the return value. `sandbox?` tells them apart.

To point a client at a different backend entirely, such as a local mock, a recording proxy, or Amazon's [Sample AI Sandbox for SP-API](https://github.com/amzn/selling-partner-api-samples/tree/main/local-ai-sandbox) (default `http://localhost:9001`), pass `base_url:` in place of `region:`:

```ruby
local = Peddler::Client.new(base_url: "http://localhost:9001", access_token: "test")
```

`base_url` is a scheme, a host and an optional port, with no path. Plain `http` is accepted for `localhost` and loopback addresses only, so that a token is never sent unencrypted over a network. A client with a `base_url` has no sandbox: `sandbox` raises `ArgumentError`.

## Testing

Once WebMock is loaded, Peddler's requests go through it: Peddler loads an adapter of its own before the next one. A test suite requires nothing of Peddler's.

```ruby
require "webmock/minitest"

class OrderTest < Minitest::Test
  def test_gets_an_order
    url = "https://sellingpartnerapi-eu.amazon.com/orders/v0/orders/123-1234567-1234567"
    stub_request(:get, url)
      .to_return(body: JSON.generate(payload: { AmazonOrderId: "123-1234567-1234567" }))
    client = Peddler.new(region: "eu-west-1", access_token: "token")

    order = client.orders_v0.get_order("123-1234567-1234567")

    assert_equal("123-1234567-1234567", order.dig("payload", "AmazonOrderId"))
    assert_requested(:get, url, headers: { "X-Amz-Access-Token" => "token" })
  end
end
```

While WebMock is enabled, every exchange goes through it: operations and `request`, the token requests of `Peddler::LWA`, and the downloads and uploads of signed URLs.

Only the exchange is replaced. A stubbed response is retried, paginated, parsed and raised on as one from Amazon is, and every attempt is a request to `assert_requested`. `to_timeout` raises `Peddler::TimeoutError`, or `Peddler::DocumentTimeoutError` for a signed URL. `to_raise` raises the error you give it.

With `retries:` set, a stubbed 429 waits as a real one does: a minute for `get_orders`. Give the stub a `Retry-After: 0` header, or the call a fast `rate_limit:`.

A request without a stub raises `WebMock::NetConnectNotAllowedError` when connections are disabled. The message is WebMock's and shows the request with its headers, the access token among them.

A document is not streamed while WebMock is enabled. An upload is read to its end before it is sent, and a download arrives whole. An upload is held in memory several times over, about eight times its size at the peak.

WebMock keeps only the last value of a repeated parameter, so a stub and a cassette see only the last SKU of `list_prep_details` and `list_item_compliance_details` of Fulfillment Inbound 2024-03-20. [Tests](UPGRADING.md#6-tests) in the upgrade guide has the setting that shows them all.

`require "peddler/webmock"` loads the adapter early, which only two kinds of program need. A suite that passes `except:` to `WebMock.enable!` or `WebMock.disable!` before Peddler's first request puts the line before that call. An adapter that loads later can't see the call: after `WebMock.enable!(except: [:net_http])` the request is sent. The other is a call from another Ractor, under [Ractors](#ractors).

VCR records and replays Peddler's requests once it hooks into WebMock.

```ruby
require "vcr"

VCR.configure do |config|
  config.hook_into(:webmock)
  config.cassette_library_dir = "test/cassettes"
  config.filter_sensitive_data("<ACCESS_TOKEN>") { access_token }
end

item = VCR.use_cassette("catalog_item") do
  client.catalog_items.get_catalog_item("B08N5WRWNW", Peddler::Marketplace.ids("US"))
end
```

A test can also run against a server it starts. Point the client at it with `base_url:`, and `Peddler::LWA` with `lwa_endpoint:`.

## Pagination

An operation that returns its results in pages has a twin that ends in `_pages`. It takes the same arguments and returns a lazy `Enumerator` of responses, one per page.

```ruby
pages = client.orders_v0.get_orders_pages(Peddler::Marketplace.ids("UK"), created_after: "2026-01-01T00:00:00Z")
pages.each do |page|
  page.parse.payload.orders.each { |order| puts order.amazon_order_id }
end
```

It requests a page only when you ask for it. `pages.first(2)` makes two requests, and breaking out of `each` makes no more.

79 operations have a `_pages` twin. The enumerator ends when a page carries no token for the next one. To continue from a token you saved, pass it as you would to the operation, for example `next_token:`.

A page that is an HTTP error raises `Peddler::Error`. If a page returns the token it was requested with, or a token that is not a String, the enumerator yields that page and then raises `Peddler::PaginationError`, whose `reason` says which.

Where an operation has no twin, read the token from the response and pass it to the next call yourself.

## Documents and workflows

Reports, feeds and Data Kiosk queries exchange documents through signed URLs. Peddler waits for a job to finish and downloads or uploads its document. These helpers are on `client.reports`, `client.feeds` and `client.data_kiosk`, beside the operations of each API.

```ruby
report_id = client.reports.create_report({
  "reportType" => "GET_MERCHANT_LISTINGS_ALL_DATA",
  "marketplaceIds" => Peddler::Marketplace.ids("UK"),
}).parse.report_id

report = client.reports.wait_for_report(report_id).parse
if report.processing_status == "DONE"
  listings = client.reports.download_report_document(report.report_document_id).to_s
end
```

| API | Waits | Opens a document to stream | Returns a whole document | Uploads |
| --- | --- | --- | --- | --- |
| `client.reports` | `wait_for_report` | `open_report_document` | `download_report_document` | |
| `client.feeds` | `wait_for_feed` | `open_feed_document` | `download_result_feed_document` | `upload_feed_document`, `create_and_upload_feed_document` |
| `client.data_kiosk` | `wait_for_query` | `open_query_document` | `download_query_document` | |

`wait_for_report`, `wait_for_feed` and `wait_for_query` poll until the job is `DONE`, `CANCELLED` or `FATAL`, and return that response, so check `processing_status`. They take `interval:` (5 seconds) and `timeout:` (300 seconds), and raise `Peddler::WorkflowTimeoutError` when time runs out. A single poll that takes longer than the client's `timeout:` raises `Peddler::TimeoutError`, as any request does. A poll is retried as the client's `retries:` says, and a wait before a retry ends when the time of the whole wait runs out.

Four helpers return a whole document in a response. They allow 600 seconds for a call.

| Helper | Takes |
| --- | --- |
| `client.reports.download_report_document` | a report document ID or its URL |
| `client.feeds.upload_feed_document` | the upload URL, the content and its content type |
| `client.feeds.download_result_feed_document` | the URL of a feed result document |
| `client.data_kiosk.download_query_document` | a Data Kiosk document ID or its URL |

Given an ID, they decompress a document that Amazon compressed. Given a URL, they decompress it when the reply says `Content-Encoding: gzip`. `to_s` returns the text in the charset Amazon declares, and `body` the bytes.

### Streaming a document

A large document doesn't need to fit in memory. `open_report_document`, `open_feed_document` and `open_query_document` take a document ID and yield a `Peddler::Document` that reads the download as it arrives.

```ruby
client.reports.open_report_document(report.report_document_id) do |document|
  document.each_tsv do |row|
    puts row.first
  end
end
```

A document reads in one of four ways:

- `each_tsv` yields each row of a tab-separated report as an Array of Strings. The first row holds the column names.
- `each_jsonl` yields each line of a JSON Lines document, such as a Data Kiosk result, parsed.
- `each_chunk` yields the bytes as they arrive.
- `json(max_bytes:)` returns a whole JSON document, parsed, if it is no larger than `max_bytes`.

Without a block, the `each_` methods return an Enumerator. Numbers with a fraction parse as `BigDecimal`. `document.headers` reads the headers of the download as `response.headers` does.

`open_report_document`, `open_feed_document`, `open_query_document` and `download_document` take three options.

| Option | Limits | Default |
| --- | --- | --- |
| `timeout:` | the seconds the whole download may take | 30 |
| `max_bytes:` | the size of the document once decompressed | none |
| `max_record_bytes:` | the memory 1 row may take, its fields included | 1 MiB |

```ruby
client.reports.open_report_document(report.report_document_id, timeout: 120) do |document|
  document.each_tsv { |row| puts row.first }
end
```

The timeout covers the whole call: looking the document up by its ID, with its retries and the waits before them, then downloading it. A download that runs past it raises `Peddler::DocumentTimeoutError`. If looking the document up takes that long, it raises `Peddler::TimeoutError`, as any request does.

An option that breaks its rule raises `ArgumentError` that names it, such as `max_bytes must be a positive Integer that fits in 64 bits`. An unknown one raises `unknown option: the options are timeout, compression, max_bytes and max_record_bytes`. An upload and a wait name a bad option in the same way.

An ID that is empty, `.` or `..` is refused by name too, before any request: `document_id must not be empty`.

`each_tsv` decodes text from the charset in the document's `Content-Type`, such as `Cp1252` or `Shift_JIS`, and yields UTF-8. `document.charset` returns that label. If Amazon labels a document wrongly, name the charset yourself.

```ruby
client.reports.open_report_document(report.report_document_id) do |document|
  document.each_tsv(charset: "UTF-8") { |row| puts row.first }
end
```

### Uploading a feed

`create_and_upload_feed_document` creates a feed document and uploads your content to it. It takes a String or anything that responds to `read(length)`, such as a File, and returns the feed document ID. It doesn't create the feed.

```ruby
feed_document_id = File.open("feed.json", "rb") do |file|
  client.feeds.create_and_upload_feed_document(file, content_type: "application/json; charset=UTF-8")
end

feed_id = client.feeds.create_feed({
  "feedType" => "JSON_LISTINGS_FEED",
  "marketplaceIds" => Peddler::Marketplace.ids("UK"),
  "inputFeedDocumentId" => feed_document_id,
}).parse.feed_id

feed = client.feeds.wait_for_feed(feed_id).parse
result = client.feeds.open_feed_document(feed.result_feed_document_id) do |document|
  document.json(max_bytes: 10_000_000)
end
report = Peddler::Feeds::ListingsFeedProcessingReportSchema.parse(result)
report.summary.messages_accepted # => 2
```

An upload declares its length when it can tell it: a String, and a source that answers `size`, such as a File or a StringIO, are sent with `Content-Length`. For another source, pass `content_length:` with the number of bytes it holds. Without one, the body is sent chunked. This holds for `upload_feed_document` and `upload_document` too.

If creating the feed document takes longer than the upload's `timeout:` (30 seconds), it raises `Peddler::TimeoutError`. If the upload does, it raises `Peddler::DocumentTimeoutError`. Creating the document is retried as the client's `retries:` says, which for a write means after a 429 only. The upload is never retried.

### Signed URLs

For a signed URL you already hold, use `download_document` and `upload_document` on the client: a signed URL belongs to no API. Neither sends the access token, and both take `timeout:`. Pass `compression: :gzip` to `download_document` when the document's metadata says `GZIP`.

```ruby
client.download_document(download_url) do |document|
  document.each_chunk { |chunk| file.write(chunk) }
end

client.upload_document(upload_url, "<xml/>", content_type: "text/xml; charset=UTF-8")
```

A signed URL that answers outside 2xx raises `Peddler::Error`. Its `response` holds the reply.

A token source is asked before every poll of a `wait_for_*` method, and before a document is looked up by its ID or a feed document is created, with each retry of those. A signed URL takes no token, so a transfer asks for none.

## Ractors

Peddler works in a Ractor other than the main one: operations, `request`, `*_pages`, the document and wait helpers, and `Peddler::LWA`.

```ruby
ractor = Ractor.new(access_token) do |token|
  Peddler.new(region: "eu-west-1", access_token: token).sellers.get_marketplace_participations.to_h
end
participations = ractor.value # ractor.take before Ruby 4.0
```

- Build the client in the Ractor that uses it. A client, a `Peddler::LWA` and a `Peddler::Document` can't be copied, moved or made shareable. Building one is cheap: clients in every Ractor share the one connection pool.
- A callable token source belongs to the Ractor that made it, and is asked there before every attempt. So does `lwa.token_source`: each Ractor that builds one refreshes for itself. To share a token, pass each Ractor a String, or a source that reads a store outside the process.
- A response crosses to another Ractor as a copy, or made shareable with `Ractor.make_shareable`. A shareable response is frozen and parses its body on every `to_h`. Don't move one on Ruby 3.3 or 3.4: it arrives empty on 3.3, and with a corrupted body on 3.4.
- An error raised in a Ractor reaches whoever takes its value as the `cause` of a `Ractor::RemoteError`, with its `status`, `code`, `request_id` and `response`.
- On Ruby 3.3, call `Peddler.eager_load!` in the main Ractor before you start another that uses a typed model. The typed models load on first use, and Ruby 3.3 loads code in the main Ractor only. The call loads them all. From Ruby 3.4 a Ractor loads a model itself.
- WebMock works in the main Ractor only. While it is enabled, a call from another Ractor raises `Ractor::IsolationError` and sends nothing. So does one made while WebMock is loaded and Peddler's adapter is not: `require "peddler/webmock"` in the main Ractor first.
- On Ruby 3.3 and 3.4, don't fork while other Ractors run. Ruby hangs most such children and crashes some, with or without Peddler.

How far Ractors scale is up to Ruby. On Ruby 3.3 and 3.4, four Ractors together parse less than one does alone: about half as many typed responses. On Ruby 4.0 they parse two to three times as many.

## Available APIs

Peddler provides Ruby interfaces to all Amazon SP-API endpoints. Each API is available in its respective version. Access APIs by calling methods on the client:

```ruby
client.<api_name>_<version>.<operation>(...)
```

You can also use the latest version:

```ruby
client.<api_name>.<operation>(...)
```

Available APIs by category:

### Orders and Financial APIs

- **Orders API**: Retrieve and manage orders
- **Finances API**: Financial data, payments, refunds
- **Invoices API**: Manage billing invoices
- **Sales API**: Order metrics and sales data

```ruby
response = client.orders.search_orders(
  marketplace_ids: Peddler::Marketplace.ids("US"),
  created_after: "2026-01-01T00:00:00Z",
)
orders = response.parse.orders
```

### Catalog and Listing APIs

- **Catalog Items API**: Access Amazon's catalog data
- **Listings Items API**: Create and update listings
- **Listings Restrictions API**: Check listing eligibility
- **Product Type Definitions API**: Get schema requirements for listings
- **A+ Content API**: Create and manage enhanced marketing content
- **Product Pricing API**: Get pricing information
- **Product Fees API**: Retrieve fee estimates for products

```ruby
response = client.catalog_items.get_catalog_item(
  "B08N5WRWNW",
  Peddler::Marketplace.ids("US"),
  included_data: ["summaries", "images"],
)
item = response.parse
```

### Fulfillment and Inventory APIs

- **Fulfillment Inbound API**: Send inventory to FBA
- **Fulfillment Outbound API**: Create and track FBA orders
- **FBA Inventory API**: Manage FBA inventory quantities
- **FBA Inbound Eligibility API**: Check product eligibility for FBA
- **Merchant Fulfillment API**: Create shipping labels for self-fulfilled orders
- **Easy Ship API**: Manage Amazon's carrier service
- **Shipping APIs**: Create shipments and purchase shipping labels
- **Replenishment API**: Manage inventory replenishment
- **Amazon Warehousing and Distribution API**: Manage fulfillment warehousing
- **Supply Sources API**: Manage supply/inventory sources
- **Shipment Invoicing API**: Manage shipment-related invoices

```ruby
marketplace_id = Peddler::Marketplace.id("US")
response = client.fba_inventory.get_inventory_summaries(
  "Marketplace",
  marketplace_id,
  [marketplace_id],
  details: true,
)
summaries = response.parse.payload.inventory_summaries
```

### Data Management APIs

- **Feeds API**: Upload data to Amazon (listings, prices, inventory, etc.)
- **Reports API**: Request and download reports (orders, inventory, fulfillment, etc.)
- **Uploads API**: Upload files for various SP-API operations
- **Data Kiosk API**: Access analytical data with GraphQL queries

```ruby
# Feeds API - create feed document, upload, submit
feeds = client.feeds
document = feeds.create_feed_document({ "contentType" => "text/xml; charset=UTF-8" })
feeds.upload_feed_document(document.dig("url"), File.read("feed.xml"), "text/xml; charset=UTF-8")
feed = feeds.create_feed({
  "feedType" => "POST_INVENTORY_AVAILABILITY_DATA",
  "marketplaceIds" => ["ATVPDKIKX0DER"],
  "inputFeedDocumentId" => document.dig("feedDocumentId"),
})
```

### Data Kiosk API

The Data Kiosk API provides access to Amazon's analytical data through GraphQL queries. Peddler supports four Data Kiosk schemas, each with type-safe classes for parsing responses.

**Available Schemas:**

- **SalesAndTraffic20240424**: Sales and traffic metrics by ASIN and date
- **Economics20240315**: Economics and profitability data
- **SellerAnalytics20250331**: Seller analytics
- **VendorAnalytics20240930**: Vendor-specific analytics and forecasting data

```ruby
response = client.data_kiosk.create_query({
  "query" => "query { analytics_salesAndTraffic_2024_04_24 { salesAndTrafficByDate(...) { startDate sales { unitsOrdered } } } }",
})
query = client.data_kiosk.wait_for_query(response.parse.query_id).parse

client.data_kiosk.open_query_document(query.data_document_id) do |document|
  document.each_jsonl do |row|
    by_date = Peddler::DataKiosk::SalesAndTraffic20240424::SalesAndTrafficByDate.parse(row)
    puts by_date.start_date
  end
end
```

### Vendor APIs

- **Vendor Orders API**: Retrieve purchase orders
- **Vendor Direct Fulfillment Orders API**: Manage direct fulfillment orders
- **Vendor Direct Fulfillment Shipping API**: Manage shipping for direct fulfillment
- **Vendor Direct Fulfillment Payments API**: Process payments for direct fulfillment
- **Vendor Direct Fulfillment Inventory API**: Manage inventory for direct fulfillment
- **Vendor Direct Fulfillment Transactions API**: Track transaction status
- **Vendor Direct Fulfillment Sandbox Test Data API**: Generate test data in sandbox
- **Vendor Shipments API**: Track vendor shipments
- **Vendor Invoices API**: Submit and track invoices
- **Vendor Transaction Status API**: Check transaction status

```ruby
orders = client.vendor_orders.get_purchase_orders(limit: 10, created_after: "2026-01-01T00:00:00Z").parse
```

### Authorization and Account Management APIs

- **Application Management API**: Manage application authorization
- **Tokens API**: Generate restricted data tokens for accessing PII
- **Sellers API**: Get seller account information and marketplace participation
- **Services API**: Manage seller services and subscriptions
- **Seller Wallet API**: Manage seller financial accounts
- **Application Integrations API**: Manage app integrations
- **Vehicles API**: Manage vehicle data for automotive products

## Complex Workflows

Peddler parses notifications, JSON reports, feed processing reports and Data Kiosk rows into typed objects too. Each has a `parse` method that takes the parsed JSON.

```ruby
# A notification from your queue
notification = Peddler::Notifications::OrderChange.parse(JSON.parse(message_body))
notification.notification_type # => "ORDER_CHANGE"
```

Tests that replay recorded responses show more:

- **Feeds API**: [test/peddler/apis/feeds_2021_06_30_test.rb](test/peddler/apis/feeds_2021_06_30_test.rb)
- **Data Kiosk API**: [test/peddler/apis/data_kiosk_2023_11_15_test.rb](test/peddler/apis/data_kiosk_2023_11_15_test.rb)
- **Reports API**: [test/peddler/apis/reports_2021_06_30_test.rb](test/peddler/apis/reports_2021_06_30_test.rb)
- **Notifications**: [lib/peddler/notifications/](lib/peddler/notifications/) (type-safe parsing)

The operations of every API are documented in [lib/peddler/native/apis.rb](lib/peddler/native/apis.rb), and their signatures are in [sig/inline/peddler/native/apis.rbs](sig/inline/peddler/native/apis.rbs). The typed models are under [lib/peddler/apis/](lib/peddler/apis/).

For a complete list of available APIs and their detailed documentation, refer to the [API models repository][openapi-models].

## Best practices

Writing efficient SP-API code? See the [Peddler skill](skills/building-with-peddler/SKILL.md) and [Amazon SP-API skill](skills/amazon-sp-api/SKILL.md) for cutting call volume, batching, caching, API versions, reports, and error handling.

[api-docs]: https://developer-docs.amazon.com/sp-api/docs/welcome
[register-as-developer]: https://developer-docs.amazon.com/sp-api/docs/registering-as-a-developer
[register-application]: https://developer-docs.amazon.com/sp-api/docs/registering-your-application
[openapi-models]: https://github.com/amzn/selling-partner-api-models
[api-samples]: https://github.com/amzn/selling-partner-api-samples
[view-credentials]: https://developer-docs.amazon.com/sp-api/docs/viewing-your-application-information-and-credentials
[authorization]: https://developer-docs.amazon.com/sp-api/docs/authorizing-selling-partner-api-applications
[grantless-operations]: https://developer-docs.amazon.com/sp-api/docs/grantless-operations
[rate-limits]: https://developer-docs.amazon.com/sp-api/docs/usage-plans-and-rate-limits
[tokens-guide]: https://developer-docs.amazon.com/sp-api/docs/tokens-api-use-case-guide
