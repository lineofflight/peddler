# Peddler

Peddler is a Ruby interface to the [Amazon Selling Partner API (SP-API)][api-docs]. The SP-API enables Amazon sellers and vendors to programmatically access their data on orders, shipments, payments, and more.

Peddler is automatically generated from the latest Open API models provided by Amazon. A nightly job tracks Amazon's spec changes, so new endpoints and fields land shortly after Amazon publishes them. Model changes are not considered breaking and don't trigger a major version bump.

Peddler covers all SP-API endpoints, reports, notifications, and feeds. Requests run on a Rust core that ships with the gem as a native extension. The same core is available to Rust programs as the [`peddler` crate](crates/peddler/README.md).

<img src="https://github.com/lineofflight/peddler/blob/main/images/peddler.jpg?raw=true" alt="Peddler" style="max-width: 830px" />

Coming from Peddler 5? See [UPGRADING.md](UPGRADING.md).

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

Each carries a build for Ruby 3.3, 3.4 and 4.0 and needs no compiler.

On any other platform, including Alpine and other musl Linux, Bundler installs the source gem and compiles the extension during installation. That needs:

- a current stable Rust toolchain with `cargo` on `PATH` (see [rustup](https://rustup.rs)); Peddler is built and tested with Rust 1.98
- the Ruby headers (`ruby-dev` or `ruby-devel` on Linux)
- `clang` and `libclang`
- network access to crates.io

Windows is not supported.

To compile from source where a precompiled gem exists, run `gem install peddler --platform ruby` or `bundle config set force_ruby_platform true`.

### Agent skills

Install the skills for agents:

```shell
# Install both skills
npx skills add lineofflight/peddler

# Or install individually
npx skills add lineofflight/peddler -s building-with-peddler
npx skills add lineofflight/peddler -s amazon-sp-api
```

- `building-with-peddler`: Ruby integration, tokens, retries, pagination, and documents.
- `amazon-sp-api`: Language-agnostic OpenAPI spec research, issue hunting, and discussions.

## Usage

### Authorization

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
client = Peddler::Client.new(
  region: "eu-west-1",
  access_token: -> {
    Rails.cache.fetch("lwa/#{seller.id}", expires_in: 55.minutes) do
      lwa.refresh(refresh_token: seller.refresh_token).access_token
    end
  },
)
```

The client calls it before every request, on the thread that makes the request. Keep it thread-safe.

In a single process, `token_source` does the same without a cache of your own. It keeps 1 access token in memory, requests the next one 60 seconds before the old one expires and makes 1 request at a time, however many threads ask.

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

`Peddler::LWA` makes 1 request per call and keeps nothing. If Amazon rejects a request, it raises `Peddler::AuthenticationError` with the HTTP `status` and Amazon's `code`, such as `"invalid_grant"`.

### The client

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

A request body is a Hash with the field names Amazon documents. A String that holds JSON also works.

```ruby
response = client.reports.create_report({
  "reportType" => "GET_MERCHANT_LISTINGS_ALL_DATA",
  "marketplaceIds" => Peddler::Marketplace.ids("UK"),
})
```

The client takes 2 options. `timeout:` is the number of seconds a whole call may take, 30 by default. `retries:` is described under [Rate limiting](#rate-limiting).

To call with another token, for another seller or with a [restricted data token](#restricted-data-tokens-rdt-and-pii), take a view of the client. `with_access_token` accepts what `access_token:` accepts.

```ruby
other = client.with_access_token(other_seller.access_token)
other.sellers.get_marketplace_participations
```

All clients and views in a process share 1 connection pool, so creating a client for each job or request is cheap.

After `fork`, create your clients in the child process. A client or token source created before the fork raises `Peddler::ForkError` in the child. With a preloading server such as Puma or Unicorn, create clients when you need them, not at boot.

### Restricted Data Tokens (RDT) and PII

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

### Rate limiting

Amazon's SP-API imposes [rate limits][rate-limits] on operations. Peddler does not pace your calls: a client cannot know how many processes share a seller's quota. Space calls in your application, for example in your job queue. Amazon returns the limit of most operations in the `x-amzn-RateLimit-Limit` response header.

Provide an optional `retries:` argument when creating a client to specify retry attempts if throttled. Default is 0 (no retries). The most is 10.

```ruby
client = Peddler::Client.new(region: "eu-west-1", access_token: access_token, retries: 3)
client.orders_v0.get_orders(Peddler::Marketplace.ids("UK"), created_after: "2026-01-01T00:00:00Z")
```

Peddler retries a GET that Amazon answers with 429, 500, 502, 503 or 504. It waits as long as `Retry-After` asks, up to 30 seconds, and otherwise backs off exponentially with jitter. It never retries a request that changes data.

`timeout:` covers the whole call: every attempt and every wait between them. When retries run out, or the next wait doesn't fit in the time left, the last response raises `Peddler::Error` like any other.

### Typed Responses

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

#### Hash Access

If you prefer working with plain hashes instead of typed Data objects:

```ruby
# Use .to_h to get raw Hash
orders = response.to_h["payload"]["Orders"]

# Or use .dig directly (delegates to .to_h)
orders = response.dig("payload", "Orders")
```

#### Status, headers and body

```ruby
response.status.success?                 # => true
response.code                            # => 200
response.headers["x-amzn-RequestId"]     # => "a1b2c3d4-..."
response.headers["x-amzn-RateLimit-Limit"] # => "0.0167"
response.body                            # the bytes as they arrived
response.to_s                            # the body as text, in the charset Amazon declares
```

### Error Handling

All HTTP errors (4xx and 5xx) raise `Peddler::Error`. Errors expose Amazon's `message`, the HTTP `status`, Amazon's error `code`, the `request_id` and the underlying `response`, and support pattern matching on `status` and `code`:

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

There is 1 error class for every HTTP error. Tell them apart by `code`, such as `"QuotaExceeded"`, `"InvalidInput"` or `"Unauthorized"`.

A failure that is not an HTTP error response from the API has a class of its own. None of these descends from `Peddler::Error`.

| Error | Raised when |
| --- | --- |
| `Peddler::TransportError` | A request got no response: DNS, connection or TLS failed. |
| `Peddler::TimeoutError` | A call ran past its `timeout:`. A `Peddler::TransportError`. |
| `Peddler::AuthenticationError` | Login with Amazon rejected a token request. Has `status` and `code`. |
| `Peddler::PaginationError` | A `*_pages` enumerator cannot continue. Has `reason`. |
| `Peddler::DocumentError` | A document transfer failed, or a document is not what the reader expects. |
| `Peddler::DocumentTimeoutError` | A document transfer ran past its `timeout:`. A `Peddler::DocumentError`. |
| `Peddler::WorkflowError` | A document's metadata is unusable, or a report, feed or query has a status Peddler doesn't know. |
| `Peddler::WorkflowTimeoutError` | A `wait_for_*` call ran past its `timeout:`. A `Peddler::WorkflowError`. |
| `Peddler::ForkError` | A client or token source created before `fork` is used in the child. |
| `ArgumentError` | An argument is missing or has the wrong type. Nothing was sent. |

### Sandbox and custom endpoints

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

### Pagination

An operation that returns its results in pages has a twin that ends in `_pages`. It takes the same arguments and returns a lazy `Enumerator` of responses, 1 per page.

```ruby
pages = client.orders_v0.get_orders_pages(Peddler::Marketplace.ids("UK"), created_after: "2026-01-01T00:00:00Z")
pages.each do |page|
  page.parse.payload.orders.each { |order| puts order.amazon_order_id }
end
```

It requests a page only when you ask for it. `pages.first(2)` makes 2 requests, and breaking out of `each` makes no more.

79 operations have a `_pages` twin. The enumerator ends when a page carries no token for the next one. To continue from a token you saved, pass it as you would to the operation, for example `next_token:`.

A page that is an HTTP error raises `Peddler::Error`. If a page returns the token it was requested with, or a token that is not a String, the enumerator yields that page and then raises `Peddler::PaginationError`, whose `reason` says which.

Where an operation has no twin, read the token from the response and pass it to the next call yourself.

### Documents and workflows

Reports, feeds and Data Kiosk queries exchange documents through signed URLs. Peddler waits for a job to finish and downloads or uploads its document.

```ruby
report_id = client.reports.create_report({
  "reportType" => "GET_MERCHANT_LISTINGS_ALL_DATA",
  "marketplaceIds" => Peddler::Marketplace.ids("UK"),
}).parse.report_id

report = client.wait_for_report(report_id).parse
if report.processing_status == "DONE"
  listings = client.reports.download_report_document(report.report_document_id).to_s
end
```

`wait_for_report`, `wait_for_feed` and `wait_for_query` poll until the job is `DONE`, `CANCELLED` or `FATAL`, and return that response, so check `processing_status`. They take `interval:` (5 seconds) and `timeout:` (300 seconds), and raise `Peddler::WorkflowTimeoutError` when time runs out.

4 helpers return a whole document in a response. They allow 600 seconds for a call.

| Helper | Takes |
| --- | --- |
| `client.reports.download_report_document` | a report document ID or its URL |
| `client.feeds.upload_feed_document` | the upload URL, the content and its content type |
| `client.feeds.download_result_feed_document` | the URL of a feed result document |
| `client.data_kiosk.download_query_document` | a Data Kiosk document ID or its URL |

Given an ID, they decompress a document that Amazon compressed. Given a URL, they decompress it when the reply says `Content-Encoding: gzip`. `to_s` returns the text in the charset Amazon declares, and `body` the bytes.

#### Streaming a document

A large document doesn't need to fit in memory. `open_report_document`, `open_feed_document` and `open_query_document` take a document ID and yield a `Peddler::Document` that reads the download as it arrives.

```ruby
client.open_report_document(report.report_document_id) do |document|
  document.each_tsv do |row|
    puts row.first
  end
end
```

A document reads in 1 of 4 ways:

- `each_tsv` yields each row of a tab-separated report as an Array of Strings. The first row holds the column names.
- `each_jsonl` yields each line of a JSON Lines document, such as a Data Kiosk result, parsed.
- `each_chunk` yields the bytes as they arrive.
- `json(max_bytes:)` returns a whole JSON document, parsed, if it is no larger than `max_bytes`.

Without a block, the `each_` methods return an Enumerator. Numbers with a fraction parse as `BigDecimal`.

These methods take `timeout:`, the seconds the whole download may take (30 by default), `max_bytes:`, the most the document may hold once decompressed (no limit by default), and `max_record_bytes:`, the most a single row may hold (1 MiB by default). Running past the timeout raises `Peddler::DocumentTimeoutError`.

`each_tsv` decodes text from the charset in the document's `Content-Type`, such as `Cp1252` or `Shift_JIS`, and yields UTF-8. `document.charset` returns that label. If Amazon labels a document wrongly, name the charset yourself.

```ruby
client.open_report_document(report.report_document_id) do |document|
  document.each_tsv(charset: "UTF-8") { |row| puts row.first }
end
```

#### Uploading a feed

`create_and_upload_feed_document` creates a feed document and uploads your content to it. It takes a String or anything that responds to `read(length)`, such as a File, and returns the feed document ID. It doesn't create the feed.

```ruby
feed_document_id = File.open("feed.json", "rb") do |file|
  client.create_and_upload_feed_document(file, content_type: "application/json; charset=UTF-8")
end

feed_id = client.feeds.create_feed({
  "feedType" => "JSON_LISTINGS_FEED",
  "marketplaceIds" => Peddler::Marketplace.ids("UK"),
  "inputFeedDocumentId" => feed_document_id,
}).parse.feed_id

feed = client.wait_for_feed(feed_id).parse
result = client.open_feed_document(feed.result_feed_document_id) do |document|
  document.json(max_bytes: 10_000_000)
end
report = Peddler::Feeds::ListingsFeedProcessingReportSchema.parse(result)
report.summary.messages_accepted # => 2
```

#### Signed URLs

For a signed URL you already hold, use `download_document` and `upload_document`. They take the same options and send no access token. Pass `compression: :gzip` to `download_document` when the document's metadata says `GZIP`.

```ruby
client.download_document(download_url) do |document|
  document.each_chunk { |chunk| file.write(chunk) }
end

client.upload_document(upload_url, "<xml/>", content_type: "text/xml; charset=UTF-8")
```

A signed URL that answers outside 2xx raises `Peddler::Error`. Its `response` holds the reply.

A token source is asked once by each `wait_for_*` call and each document method, however long the call runs. Give a long wait a token that outlives it.

### Available APIs

Peddler provides Ruby interfaces to all Amazon SP-API endpoints. Each API is available in its respective version. Access APIs by calling methods on the client:

```ruby
client.<api_name>_<version>.<operation>(...)
```

You can also simply use the latest version:

```ruby
client.<api_name>.<operation>(...)
```

Available APIs by category:

#### Orders and Financial APIs

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

#### Catalog and Listing APIs

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

#### Fulfillment and Inventory APIs

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

#### Data Management APIs

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

#### Data Kiosk API

The Data Kiosk API provides access to Amazon's analytical data through GraphQL queries. Peddler supports 4 Data Kiosk schemas, each with type-safe classes for parsing responses.

**Available Schemas:**

- **SalesAndTraffic20240424**: Sales and traffic metrics by ASIN and date
- **Economics20240315**: Economics and profitability data
- **SellerAnalytics20250331**: Seller analytics
- **VendorAnalytics20240930**: Vendor-specific analytics and forecasting data

```ruby
response = client.data_kiosk.create_query({
  "query" => "query { analytics_salesAndTraffic_2024_04_24 { salesAndTrafficByDate(...) { startDate sales { unitsOrdered } } } }",
})
query = client.wait_for_query(response.parse.query_id).parse

client.open_query_document(query.data_document_id) do |document|
  document.each_jsonl do |row|
    by_date = Peddler::DataKiosk::SalesAndTraffic20240424::SalesAndTrafficByDate.parse(row)
    puts by_date.start_date
  end
end
```

#### Vendor APIs

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

#### Authorization and Account Management APIs

- **Application Management API**: Manage application authorization
- **Tokens API**: Generate restricted data tokens for accessing PII
- **Sellers API**: Get seller account information and marketplace participation
- **Services API**: Manage seller services and subscriptions
- **Seller Wallet API**: Manage seller financial accounts
- **Application Integrations API**: Manage app integrations
- **Vehicles API**: Manage vehicle data for automotive products

### Complex Workflows

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

For complete method signatures, see [sig/peddler/native/apis.rbs](sig/peddler/native/apis.rbs). The typed models are under [lib/peddler/apis/](lib/peddler/apis/).

For a complete list of available APIs and their detailed documentation, refer to the [API models repository][openapi-models].

## Best practices

Writing efficient SP-API code? See the [Peddler skill](skills/building-with-peddler/SKILL.md) and [Amazon SP-API skill](skills/amazon-sp-api/SKILL.md) for cutting call volume, batching, caching, API versions, reports, and error handling.

## Development

Development needs a stable Rust toolchain next to Ruby.

```bash
# Setup
bundle install
bundle exec rbs collection install

# Build the native extension into tmp/native
bundle exec rake native:build

# Run tests and linting
bundle exec rake

# Run tests only
bundle exec rake test

# Regenerate API classes from latest Amazon OpenAPI specs
bundle exec rake generate

# Type check with Steep
bundle exec steep check --severity-level=hint
```

`rake test` builds the extension first. The generators are described in [lib/generator/README.md](lib/generator/README.md) and [crates/peddler-codegen/README.md](crates/peddler-codegen/README.md).

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
