# Peddler

[![Build](https://github.com/lineofflight/peddler/actions/workflows/ci.yml/badge.svg)][build]

> AI Agents: See [llms.txt](llms.txt)

> **IMPORTANT:** This README is for the v5 pre-release. For the latest stable version, see the [v4.9.0 README](https://github.com/hakanensari/peddler/blob/v4.9.0/README.md).

Peddler is a Ruby interface to the [Amazon Selling Partner API (SP-API)][api-docs]. The SP-API enables Amazon sellers and vendors to programmatically access their data on orders, shipments, payments, and more.

Peddler is automatically generated from the latest Open API models provided by Amazon.

To begin using the Amazon SP-API, you must [register as a developer][register-as-developer] and [register your application][register-application]. Once registered, [obtain your Login with Amazon (LWA) credentials][view-credentials] to access your own or other selling partners' data.

- [API docs][api-docs]
- [Swagger models][swagger-models]
- [API samples][api-samples]

<img src="https://github.com/hakanensari/peddler/blob/main/images/peddler.jpg?raw=true" alt="Peddler" style="max-width: 830px" />

## Installation

Add to your Gemfile.

## Usage

### Authorization

Set your LWA credentials in your environment.

```shell
export LWA_CLIENT_ID=<YOUR_CLIENT_ID>
export LWA_CLIENT_SECRET=<YOUR_CLIENT_SECRET>
```

A seller or vendor [provides you a refresh token][authorization] to access their data on Amazon.

```ruby
response = Peddler::LWA.request(
  code: "<AUTHORIZATION_CODE>"
)
refresh_token = response.parse.refresh_token
```

Use this to generate a temporary access token to authenticate individual requests.

```ruby
response = Peddler::LWA.request(
  refresh_token: "<REFRESH_TOKEN>",
)
access_token = response.parse.access_token
```

Similarly, you can request a token for grantless operations.

```ruby
response = Peddler::LWA.request(
  scope: "sellingpartnerapi::notifications",
)
access_token = response.parse.access_token
```

In place of environment variables, you can set them directly when requesting the token.

```ruby
response = Peddler::LWA.request(
  client_id: "<YOUR_CLIENT_ID>",
  client_secret: "<YOUR_CLIENT_SECRET>",
  refresh_token: "<REFRESH_TOKEN>",
)
access_token = response.parse.access_token
```

Access tokens are valid for one hour. To optimize performance, cache and reuse across calls.

For example,

```ruby
class Seller
  attr_reader :refresh_token

  def access_token
    Rails.cache.fetch("#{cache_key}/access_key", expires_in: 1.hour) do
      Peddler::LWA.request(refresh_token:).parse.access_token
    end
  end
end
```

### Rate limiting

Amazon's SP-API imposes [rate limits][rate-limits] on operations. Override the default value by passing a `:rate_limit` parameter when calling an operation.

Provide an optional `:retries` argument when initializing an API to specify retry attempts if throttled. Default is 0 (no retries). If set, Peddler retries with exponential backoff.

```ruby
api = Peddler.orders_v0.new(aws_region, access_token, retries: 3)
api.get_orders("...": "...")
```

### Typed Responses

Peddler provides typed response parsing using the [Structure gem](https://github.com/hakanensari/structure), offering runtime type checking and better IDE support. Types are based on Ruby's [Data class](https://docs.ruby-lang.org/en/3.4/Data.html) and are lazy-loaded.

```ruby
api = Peddler.orders.new(aws_region, access_token)

# Get orders with type-safe response
response = api.get_orders("...": "...")

# Use .parse to get typed Data objects
orders = response.parse.payload.orders  # Returns array of Order Data objects
order = orders.first

# Type-safe attribute access
order.amazon_order_id     # => "123-4567890-1234567"
order.order_status        # => "Shipped"
order.prime?              # => true
order.order_total         # => Money object (automatic coercion)
order.order_total.cents   # => 9999
order.order_total.currency.iso_code # => "USD"
```

#### Hash Access

If you prefer working with plain hashes instead of typed Data objects:

```ruby
api = Peddler.orders.new(aws_region, access_token)
response = api.get_orders(marketplaceIds: ["ATVPDKIKX0DER"])

# Use .to_h to get raw Hash
orders = response.to_h["payload"]["orders"]

# Or use .dig directly (delegates to .to_h)
orders = response.dig("payload", "orders")
```

### Error Handling

All HTTP errors (4xx and 5xx) raise `Peddler::Error` exceptions:

```ruby
begin
  response = api.get_orders(marketplaceIds: ["ATVPDKIKX0DER"])
  orders = response.parse["payload"]["orders"]
rescue Peddler::Error => e
  puts "API Error: #{e.message}"
  puts "Status: #{e.response.status}"

  # Handle retries for server errors
  if e.response.status >= 500
    # Retry logic here
  end
end
```

### Available APIs

Peddler provides Ruby interfaces to all Amazon SP-API endpoints. Each API is available in its respective version. Access APIs by calling methods on the Peddler module:

```ruby
api = Peddler.<api_name>_<version>.new(aws_region, access_token, options)
```

You can also simply use the latest version:

```ruby
api = Peddler.<api_name>.new(aws_region, access_token, options)
```

Available APIs by category:

#### Orders and Financial APIs

- **Orders API**: Retrieve and manage orders
- **Finances API**: Financial data, payments, refunds
- **Invoices API**: Manage billing invoices
- **Sales API**: Order metrics and sales data

```ruby
api = Peddler.orders.new(aws_region, access_token)
response = api.get_orders("...": "...")
orders = response.parse.payload.orders
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
api = Peddler.catalog_items.new(aws_region, access_token)
response = api.get_catalog_item("...": "...")
item = response.parse.payload
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
api = Peddler.fulfillment_outbound.new(aws_region, access_token)
response = api.create_fulfillment_order(body: { "...": "..." })
```

#### Data Management APIs

- **Feeds API**: Upload data to Amazon (listings, prices, inventory, etc.)
- **Reports API**: Request and download reports (orders, inventory, fulfillment, etc.)
- **Uploads API**: Upload files for various SP-API operations
- **Data Kiosk API**: Access analytical data with GraphQL queries

```ruby
# Feeds API - create feed document, upload, submit
api = Peddler.feeds.new(aws_region, access_token)
document = api.create_feed_document(contentType: "text/xml; charset=UTF-8")
api.upload_feed_document(document.dig("url"), File.read("feed.xml"), "text/xml")
feed = api.create_feed(feedType: "POST_INVENTORY_AVAILABILITY_DATA", marketplaceIds: ["ATVPDKIKX0DER"], inputFeedDocumentId: document.dig("feedDocumentId"))
```

#### Data Kiosk API

The Data Kiosk API provides access to Amazon's analytical data through GraphQL queries. Peddler supports four Data Kiosk schema versions, each with type-safe classes for parsing responses.

**Available Schemas:**

- **SalesAndTraffic20231115**: Sales and traffic metrics by ASIN and date
- **SalesAndTraffic20240424**: Enhanced sales and traffic data (2024)
- **Economics20240315**: Economics and profitability data
- **VendorAnalytics20240930**: Vendor-specific analytics and forecasting data

```ruby
api = Peddler.data_kiosk.new(aws_region, access_token)
response = api.create_query(query: "query { salesAndTrafficByDate(...) { data { date sales } } }")
query_id = response.dig("payload", "queryId")
# Poll for completion and download document
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
api = Peddler.vendor_orders.new(aws_region, access_token)
orders = api.get_purchase_orders(limit: 10, createdAfter: "2023-01-01T00:00:00Z").parse
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

Detailed workflows are available in test files with VCR cassettes:

- **Feeds API**: [test/peddler/apis/feeds_2021_06_30_test.rb](test/peddler/apis/feeds_2021_06_30_test.rb)
- **Data Kiosk API**: [test/peddler/apis/data_kiosk_2023_11_15_test.rb](test/peddler/apis/data_kiosk_2023_11_15_test.rb)
- **Reports API**: [lib/peddler/apis/reports_2021_06_30.rb](lib/peddler/apis/reports_2021_06_30.rb) (YARD docs)
- **Notifications API**: [lib/peddler/notifications/](lib/peddler/notifications/) (type-safe parsing)

For complete method signatures, see [sig/peddler/apis/](sig/peddler/apis/)

For a complete list of available APIs and their detailed documentation, refer to the [API models repository][swagger-models].

## Development

```bash
# Setup
bundle install
bundle exec rbs collection install

# Run tests and linting
bundle exec rake

# Run tests only
bundle exec rake test

# Regenerate API classes from latest Amazon OpenAPI specs
bundle exec rake generate

# Type check with Steep
bundle exec steep check --severity-level=hint
```

[build]: https://github.com/lineofflight/peddler/actions
[api-docs]: https://developer.amazonservices.com/sp-api-docs/overview
[register-as-developer]: https://developer-docs.amazon.com/sp-api/docs/registering-as-a-developer
[register-application]: https://developer-docs.amazon.com/sp-api/docs/registering-your-application
[swagger-models]: https://github.com/amzn/selling-partner-api-models
[api-samples]: https://github.com/amzn/selling-partner-api-samples
[view-credentials]: https://developer-docs.amazon.com/sp-api/docs/viewing-your-application-information-and-credentials
[authorization]: https://developer-docs.amazon.com/sp-api/docs/authorizing-selling-partner-api-applications
[rate-limits]: https://developer-docs.amazon.com/sp-api/docs/usage-plans-and-rate-limits
[httprb]: https://github.com/httprb/http
