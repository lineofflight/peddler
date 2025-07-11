# Peddler

[![Build](https://github.com/hakanensari/peddler/workflows/build/badge.svg)][build]

**Peddler** is a Ruby interface to the [Amazon Selling Partner API (SP-API)][docs-overview]. The SP-API enables Amazon sellers and vendors to programmatically access their data on orders, shipments, payments, and more.

Peddler is automatically generated from the latest Open API models provided by Amazon.

To begin using the Amazon SP-API, you must [register as a developer][register-as-developer] and [register your application][register-application]. Once registered, [obtain your Login with Amazon (LWA) credentials][view-credentials] to access your own or other selling partners' data.

- [API models][api-models]
- [API samples][api-samples]

<img src="https://github.com/hakanensari/peddler/blob/main/images/peddler.jpg?raw=true" alt="Peddler" style="max-width: 830px" />

## Installation

Add this line to your Gemfile.

```ruby
gem "peddler", "~> 4.0"
```

And then execute:

```shell
bundle install
```

### Optional Dependencies

For enhanced error handling when uploading or downloading files, Peddler can parse XML error responses from Amazon S3 if Nokogiri is available:

```ruby
gem "nokogiri"
```

If Nokogiri is not available, S3 XML errors will still be handled gracefully, but with less detailed error information.

## Usage

Set your LWA credentials in your environment.

```shell
export LWA_CLIENT_ID=<YOUR_CLIENT_ID>
export LWA_CLIENT_SECRET=<YOUR_CLIENT_SECRET>
```

Require the library.

```ruby
require "peddler"
```

### Authorization

A seller or vendor [provides you a refresh token][authorization] to access their data on Amazon.

```ruby
refresh_token = Peddled::Token.request(
  code: "<AUTHORIZATION_CODE>"
).parse["refresh_token"]
```

You use this to generate a temporary access token to authenticate individual API requests.

```ruby
access_token = Peddler::Token.request(
  refresh_token: "<REFRESH_TOKEN>",
).parse["access_token"]
```

Similarly, you can request a token for grantless operations.

```ruby
access_token = Peddler::Token.request(
  scope: "sellingpartnerapi::notifications",
).parse["access_token"]
```

If you haven't set your LWA credentials as environment variables, pass them directly when requesting the token.

```ruby
access_token = Peddler::Token.request(
  client_id: "<YOUR_CLIENT_ID>",
  client_secret: "<YOUR_CLIENT_SECRET>",
  refresh_token: "<REFRESH_TOKEN>",
).parse["access_token"]
```

Access tokens are valid for one hour. To optimize performance, cache the token and reuse across calls.

In Rails, if you're storing a refresh token in a model representing a selling partner, implement a method there to retrieve and cache access tokens:

```ruby
class Seller
  "..."

  def access_token
    Rails.cache.fetch("#{cache_key}/access_key", expires_in: 1.hour) do
      Peddler::Token.request(
        refresh_token:,
      ).parse["access_token"]
    end
  end
end
```

### Rate limiting

Amazon's SP-API imposes [rate limits][rate-limits] on operations. Override the default rate limit by passing a `:rate_limit` parameter when calling an operation.

Provide an optional `:retries` argument when initializing an API to specify retry attempts if throttled. Default is 0 (no retries). If set to a positive value, Peddler will retry with exponential backoff based on the rate limit.

```ruby
api = Peddler.orders_v0(aws_region, access_token, retries: 3)
api.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "2023-01-01T00:00:00Z"
)
```

### Error Handling

By default, Peddler v4 maintains backward compatibility:
- **Client errors (4xx)**: Always raise `Peddler::Error` exceptions
- **Server errors (5xx)**: Return response objects (deprecated behavior)

To adopt the recommended v5.0 behavior where all errors raise exceptions:

```ruby
Peddler.configure do |config|
  config.raise_on_server_errors = true
end
```

This ensures consistent error handling and prevents silent failures from server errors.

#### Current Default Behavior (v4.x)

```ruby
# Server errors (5xx) return response objects by default
response = api.get_orders(marketplaceIds: ["ATVPDKIKX0DER"])

# Must check status to detect server errors
if response.status >= 500
  puts "Server error: #{response.status}"
  # Handle error or retry
else
  orders = response.parse["payload"]["orders"]
end

# Client errors (4xx) always raise
begin
  response = api.get_orders(marketplaceIds: ["INVALID"])
rescue Peddler::Error => e
  puts "Client error: #{e.message}"
end
```

#### Recommended Behavior (v5.0)

Enable consistent error handling by setting `raise_on_server_errors`:

```ruby
# Configure once at application startup
Peddler.configure do |config|
  config.raise_on_server_errors = true
end

# Now all errors raise exceptions consistently
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

#### S3 Error Handling

For file upload/download operations, Amazon S3 may return XML error responses. If Nokogiri is available, these are parsed for detailed error information:

```ruby
# With Nokogiri gem
gem "nokogiri"

# Enhanced S3 error parsing
begin
  api.upload_document(document_data)
rescue Peddler::Error => e
  puts "S3 Error: #{e.message}"  # Detailed XML-parsed error
end
```

Without Nokogiri, S3 XML errors are still handled gracefully but with less detailed information.

### Available APIs

Peddler provides Ruby interfaces to all Amazon SP-API endpoints. Each API is available in its respective version. Access APIs by calling methods on the Peddler module:

```ruby
api = Peddler.<api_name>_<version>(aws_region, access_token, options)
```

You can also simply initialize the latest version:

```ruby
api = Peddler.<api_name>(aws_region, access_token, options)
```

Below is a comprehensive list of all available APIs organized by category:

#### Orders and Financial APIs

- **Orders API (v0)**: Retrieve and manage orders
- **Finances API (2024-06-19, 2024-06-01, v0)**: Get financial data including transaction details, payments, and refunds
- **Invoices API (2024-06-19)**: Manage billing invoices
- **Sales API (v1)**: Get order metrics and sales data

```ruby
api = Peddler.orders(aws_region, access_token)
response = api.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "2023-01-01T00:00:00Z"
)

# Use the `dig` method to safely navigate through nested response data
# This returns nil instead of raising an error if any key in the path doesn't exist
orders = response.dig("payload", "orders")

# You can chain multiple keys to access deeply nested data
first_order_id = response.dig("payload", "orders", 0, "amazonOrderId")

# This is safer than using chain indexing which would raise an error if any part is missing:
# response.parse["payload"]["orders"][0]["amazonOrderId"]  # Error prone!

# For sandbox testing
api.sandbox.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "TEST_CASE_200"
)
```

#### Catalog and Listing APIs

- **Catalog Items API (2022-04-01, 2020-12-01, v0)**: Access Amazon's catalog data
- **Listings Items API (2021-08-01, 2020-09-01)**: Create and update listings
- **Listings Restrictions API (2021-08-01)**: Check listing eligibility
- **Product Type Definitions API (2020-09-01)**: Get schema requirements for listings
- **A+ Content API (2020-11-01)**: Create and manage enhanced marketing content
- **Product Pricing API (2022-05-01, v0)**: Get pricing information
- **Product Fees API (v0)**: Retrieve fee estimates for products

```ruby
api = Peddler.catalog_items(aws_region, access_token)
response = api.get_catalog_item(
  marketplaceIds: ["ATVPDKIKX0DER"],
  asin: "B08N5WRWNW"
)
item_details = response.dig("payload")

# Search catalog items by identifier
response = api.search_catalog_items(
  ["ATVPDKIKX0DER"],
  identifiers: "B08N5WRWNW",
  identifiers_type: "ASIN"
)
search_results = response.parse
```

#### Fulfillment and Inventory APIs

- **Fulfillment Inbound API (2024-03-20, v0)**: Send inventory to FBA
- **Fulfillment Outbound API (2020-07-01)**: Create and track FBA orders
- **FBA Inventory API (v1)**: Manage FBA inventory quantities
- **FBA Inbound Eligibility API (v1)**: Check product eligibility for FBA
- **Merchant Fulfillment API (v0)**: Create shipping labels for self-fulfilled orders
- **Easy Ship API (2022-03-23)**: Manage Amazon's carrier service for deliveries
- **Shipping APIs (v1, v2)**: Create shipments and purchase shipping labels
- **Replenishment API (2022-11-07)**: Manage inventory replenishment
- **Amazon Warehousing and Distribution API (2024-05-09)**: Manage fulfillment warehousing
- **Supply Sources API (2020-07-01)**: Manage supply/inventory sources
- **Shipment Invoicing API (v0)**: Manage shipment-related invoices

```ruby
# FBA outbound example
api = Peddler.fulfillment_outbound(aws_region, access_token)
api.create_fulfillment_order(
  body: {
    sellerFulfillmentOrderId: "ORDER123",
    displayableOrderId: "ORDER123",
    displayableOrderDate: Time.now.iso8601,
    shippingSpeedCategory: "Standard",
    destinationAddress: {
      name: "Customer Name",
      addressLine1: "123 Main St",
      city: "Seattle",
      stateOrRegion: "WA",
      postalCode: "98101",
      countryCode: "US"
    },
    items: [
      {
        sellerSku: "SKU123",
        sellerFulfillmentOrderItemId: "ITEM123",
        quantity: 1
      }
    ]
  }
)
```

#### Data Management APIs

- **Feeds API (2021-06-30)**: Upload data to Amazon to update listings, prices, inventory, and more
- **Reports API (2021-06-30)**: Request and download reports about orders, inventory, fulfillment, and more
- **Uploads API (2020-11-01)**: Upload files for various SP-API operations
- **Data Kiosk API (2023-11-15)**: Access and manage analytical data

```ruby
api = Peddler.feeds(aws_region, access_token)

# Complete Feeds API Workflow:
# 1. Create a feed document (input feed document)
# 2. Upload content to the document
# 3. Create feed referencing the document
# 4. Wait for feed to complete (e.g., SQS notification)
# 5. Get feed document (result feed document)
# 6. Download results to see processing outcome

# Step 1: Create feed document (input document)
document_response = api.create_feed_document(
  contentType: "text/xml; charset=UTF-8"
)

# The `dig` method safely navigates the response hash
# If the response structure is:
# {
#   "feedDocumentId": "amzn1.tortuga.3.abc123...",
#   "url": "https://s3.amazonaws.com/bucket/key...",
#   "encryptionDetails": {
#     "standard": "AES",
#     "key": "encryption-key",
#     "initializationVector": "vector-value"
#   }
# }

# Access top-level keys with dig
feed_document_id = document_response.dig("feedDocumentId")
upload_url = document_response.dig("url")

# Access nested keys - returns nil if any key in the path is missing
encryption_key = document_response.dig("encryptionDetails", "key")

# Step 2: Upload feed content to the input document
feed_content = File.read("inventory_update.xml")
api.upload_feed_document(upload_url, feed_content, "text/xml; charset=UTF-8")

# Step 3: Create feed referencing the input document
feed_response = api.create_feed(
  feedType: "POST_INVENTORY_AVAILABILITY_DATA",
  marketplaceIds: ["ATVPDKIKX0DER"],
  inputFeedDocumentId: feed_document_id
)
feed_id = feed_response.dig("feedId")

# Step 4: Wait for feed to complete (polling or SQS notification)
# Poll until status is "DONE", "FATAL", or "CANCELLED"
loop do
  feed_status = api.get_feed(feed_id)
  status = feed_status.dig("processingStatus")
  break if ["DONE", "FATAL", "CANCELLED"].include?(status)
  sleep 30 # Wait 30 seconds before checking again
end

# Step 5: Get feed document (result document with processing results)
result_document_id = feed_status.dig("resultFeedDocumentId")
result_document = api.get_feed_document(result_document_id) if result_document_id

# Step 6: Download results to see processing outcome
if result_document
  download_url = result_document.dig("url")
  response = HTTP.get(download_url)
  content = if result_document.dig("compressionAlgorithm") == "GZIP"
              Zlib::GzipReader.new(response).read
            else
              response.to_s
            end
  # Parse content to check for errors/success
end

# JSON feed example
json_document = api.create_feed_document(
  { "contentType" => "application/json; charset=UTF-8" }
)
json_feed_content = JSON.generate({
  "header": {
    "sellerId": "SELLER_ID",
    "version": "2.0",
    "issueLocale": "en_US"
  },
  "messages": [
    {
      "messageId": 1,
      "sku": "SKU123",
      "operationType": "UPDATE",
      "productType": "PRODUCT",
      "attributes": {
        # Your product attributes here
      }
    }
  ]
})
api.upload_feed_document(json_document.dig("url"), json_feed_content, "application/json; charset=UTF-8")
```

#### Communication and Customer Management APIs

- **Customer Feedback API (2024-06-01)**: Analyze customer reviews and returns data at item and browse node levels
- **Notifications API (v1)**: Subscribe to notifications for events like order updates
- **Messaging API (v1)**: Send messages to customers
- **Solicitations API (v1)**: Request customer reviews

```ruby
# Customer Feedback API example
api = Peddler.customer_feedback_2024_06_01(aws_region, access_token)

# Get item review topics (most positive and negative)
review_topics = api.get_item_review_topics(
  "B08N5WRWNW",  # ASIN
  Marketplace.id("US"),
  "frequency"  # Sort by frequency
)

# Get item review trends for past 6 months
review_trends = api.get_item_review_trends(
  "B08N5WRWNW",
  Marketplace.id("US")
)

# Get browse node return topics
return_topics = api.get_browse_node_return_topics(
  "123456789",  # Browse node ID
  Marketplace.id("US")
)
```

```ruby
api = Peddler.notifications(aws_region, access_token)
# Create destination
destination = api.create_destination(
  name: "MyEventQueue",
  resourceSpecification: {
    sqs: { arn: "arn:aws:sqs:us-east-1:123456789012:MyQueue" }
  }
)
destination_id = destination.dig("payload", "destinationId")

# Create subscription
api.create_subscription(
  notificationType: "ANY_OFFER_CHANGED",
  destinationId: destination_id,
  payloadVersion: "1"
)

# For sandbox testing (requires grantless token)
sandbox_api = Peddler.notifications(aws_region, grantless_access_token).sandbox
# Get all destinations
destinations = sandbox_api.get_destinations

# Get specific subscription
subscription = sandbox_api.get_subscription("LISTINGS_ITEM_ISSUES_CHANGE")
```

#### Vendor APIs

APIs for vendors selling to Amazon:

- **Vendor Orders API (v1)**: Retrieve purchase orders
- **Vendor Direct Fulfillment Orders API (2021-12-28, v1)**: Manage direct fulfillment orders
- **Vendor Direct Fulfillment Shipping API (2021-12-28, v1)**: Manage shipping for direct fulfillment
- **Vendor Direct Fulfillment Payments API (v1)**: Process payments for direct fulfillment
- **Vendor Direct Fulfillment Inventory API (v1)**: Manage inventory for direct fulfillment
- **Vendor Direct Fulfillment Transactions API (2021-12-28, v1)**: Track transaction status
- **Vendor Direct Fulfillment Sandbox Test Data API (2021-10-28)**: Generate test data in sandbox
- **Vendor Shipments API (v1)**: Track vendor shipments
- **Vendor Invoices API (v1)**: Submit and track invoices
- **Vendor Transaction Status API (v1)**: Check transaction status

```ruby
api = Peddler.vendor_orders(aws_region, access_token)
orders = api.get_purchase_orders(
  limit: 10,
  createdAfter: "2023-01-01T00:00:00Z"
).parse
```

#### Authorization and Account Management APIs

- **Application Management API (2023-11-30)**: Manage application authorization
- **Tokens API (2021-03-01)**: Generate restricted data tokens for accessing PII
- **Sellers API (v1)**: Get seller account information and marketplace participation
- **Services API (v1)**: Manage seller services and subscriptions
- **Seller Wallet API (2024-03-01)**: Manage seller financial accounts
- **Application Integrations API (2024-04-01)**: Manage app integrations
- **Vehicles API (2024-11-01)**: Manage vehicle data for automotive products

### Additional API Examples

#### Product Pricing API

```ruby
# Using Product Pricing v0
api = Peddler.product_pricing_v0(aws_region, access_token)

# Get pricing information for an ASIN
pricing = api.get_pricing(
  Marketplace.id("US"),
  "Asin",
  asins: ["B08N5WRWNW"]
)

# Get competitive pricing for an ASIN
competitive = api.get_competitive_pricing(
  Marketplace.id("US"),
  "Asin",
  asins: ["B08N5WRWNW"]
)

# Get offers for a specific item
offers = api.get_item_offers(
  Marketplace.id("US"),
  "New",
  "B08N5WRWNW"
)

# Batch request for multiple items (2022-05-01 API)
api = Peddler.product_pricing_2022_05_01(aws_region, access_token)
batch_request = {
  requests: [
    {
      uri: "/products/pricing/2022-05-01/items/competitiveSummary",
      method: "GET",
      asin: "B08N5WRWNW",
      marketplaceId: Marketplace.id("US"),
      includedData: ["featuredBuyingOptions", "referencePrices", "lowestPricedOffers"]
    },
    # Additional items...
  ]
}
results = api.get_competitive_summary(batch_request)
```

#### Listings Items API

```ruby
api = Peddler.listings_items(aws_region, access_token)

# Create or update a listing
listing_result = api.put_listings_item(
  "SELLER_ID",
  "SKU123",
  Marketplace.id("US"),
  {
    productType: "PRODUCT",
    requirements: "LISTING_OFFER_ONLY",
    attributes: {
      merchant_suggested_asin: [{
        value: "B08N5WRWNW",
        marketplace_id: Marketplace.id("US")
      }],
      condition_type: [{
        value: "new_new",
        marketplace_id: Marketplace.id("US")
      }],
      # Additional attributes...
    }
  }
)

# Update specific listing elements with JSON Patch
patch_result = api.patch_listings_item(
  "SELLER_ID",
  "SKU123",
  Marketplace.id("US"),
  {
    productType: "PRODUCT",
    patches: [
      {
        op: "replace",
        path: "/attributes/purchasable_offer",
        value: [{
          currency: "USD",
          our_price: [{
            schedule: [{
              value_with_tax: 39.99
            }]
          }]
        }]
      }
    ]
  }
)

# Get listing details
listing = api.get_listings_item(
  "SELLER_ID",
  "SKU123",
  Marketplace.id("US"),
  included_data: "attributes,issues"
)

# Delete a listing
api.delete_listings_item("SELLER_ID", "SKU123", Marketplace.id("US"))
```

#### Listings Restrictions API

```ruby
api = Peddler.listings_restrictions(aws_region, access_token)

# Check restrictions for an ASIN
restrictions = api.get_listings_restrictions(
  "B08N5WRWNW",
  "SELLER_ID",
  Marketplace.id("US"),
  condition_type: "new_new"
)
```

#### Product Type Definitions API

```ruby
api = Peddler.product_type_definitions(aws_region, access_token)

# Get schema for a product type
definition = api.get_definitions_product_type(
  "PRODUCT",
  Marketplace.id("US"),
  requirements: "LISTING_OFFER_ONLY"
)

# Download the JSON schema
schema_url = definition.dig("schema", "link", "resource")
json_schema = HTTP.get(schema_url).parse(:json)
```

#### Reports API

```ruby
api = Peddler.reports(aws_region, access_token)

# Request a report
report_response = api.create_report({
  "reportType" => "GET_MERCHANTS_LISTINGS_FYP_REPORT",
  "marketplaceIds" => Marketplace.ids("US")
})
report_id = report_response.dig("reportId")

# Get report status
report = api.get_report(report_id)

# Get all reports of a specific type
reports = api.get_reports(report_types: ["GET_MERCHANTS_LISTINGS_FYP_REPORT"])

# Download a report document (using convenience helper)
response = api.download_report_document("DOCUMENT_ID")
# Process the downloaded report content from response.body...
```

#### Sellers API

```ruby
api = Peddler.sellers(aws_region, access_token)

# Get marketplace participations
participations = api.get_marketplace_participations
```

For a complete list of available APIs and their detailed documentation, refer to the [API models repository](https://github.com/amzn/selling-partner-api-models).

[build]: https://github.com/hakanensari/peddler/actions
[docs-overview]: https://developer.amazonservices.com/sp-api-docs/overview
[register-as-developer]: https://developer-docs.amazon.com/sp-api/docs/registering-as-a-developer
[register-application]: https://developer-docs.amazon.com/sp-api/docs/registering-your-application
[api-models]: https://github.com/amzn/selling-partner-api-models
[api-samples]: https://github.com/amzn/selling-partner-api-samples
[view-credentials]: https://developer-docs.amazon.com/sp-api/docs/viewing-your-application-information-and-credentials
[authorization]: https://developer-docs.amazon.com/sp-api/docs/authorizing-selling-partner-api-applications
[rate-limits]: https://developer-docs.amazon.com/sp-api/docs/usage-plans-and-rate-limits
[httprb]: https://github.com/httprb/http
