# Upgrading to Peddler v5.0

This guide provides instructions for upgrading from Peddler v4.x to v5.0.

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
