# Peddler

[![Build](https://github.com/hakanensari/peddler/workflows/build/badge.svg)][build]

**Peddler** is a Ruby interface to the [Amazon Selling Partner API (SP-API)][docs-overview]. The SP-API enables Amazon sellers and vendors to programmatically access their data on orders, shipments, payments, and more.

Peddler is automatically generated from the Open API models provided by Amazon.

To begin using the Amazon SP-API, you must [register as a developer][register-as-developer] and [register your application][register-application]. Once registered, [obtain your Login with Amazon (LWA) credentials][view-credentials] to access your own or other selling partners' data.

- [API models][api-models]
- [API samples][api-samples]

![Peddler](https://github.com/hakanensari/peddler/blob/main/images/peddler.jpg?raw=true)

## Installation

Add this line to your Gemfile.

```ruby
gem "peddler", "~> 4.0"
```

And then execute:

```shell
bundle install
```

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

**Note:** This functionality requires version 6 of the [HTTP library][httprb], which is not yet released. To use rate limiting, point to their main branch on GitHub.

```ruby
api = Peddler.orders_v0(aws_region, access_token, retries: 3)
api.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "2023-01-01T00:00:00Z"
)
```

### Available APIs

Peddler provides Ruby interfaces to all Amazon SP-API endpoints. Each API is available in its respective version. Access APIs by calling methods on the Peddler module:

```ruby
api = Peddler.<api_name>_<version>(aws_region, access_token, options)
```

Below are key APIs with examples of their usage:

#### Orders API (v0)

Retrieve order information and manage orders.

```ruby
api = Peddler.orders_v0(aws_region, access_token)
response = api.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "2023-01-01T00:00:00Z"
)
orders = response.parse["orders"]
```

#### Catalog Items API (2022-04-01, 2020-12-01, v0)

Access Amazon's catalog data including product details, offers, and competitive pricing.

```ruby
api = Peddler.catalog_items_2022_04_01(aws_region, access_token)
response = api.get_catalog_item(
  marketplaceIds: ["ATVPDKIKX0DER"],
  asin: "B08N5WRWNW"
)
item_details = response.parse["payload"]
```

#### Feeds API (2021-06-30)

Upload data to Amazon to update listings, prices, inventory, and more.

```ruby
api = Peddler.feeds_2021_06_30(aws_region, access_token)

# Create feed document
document_response = api.create_feed_document(
  contentType: "text/xml; charset=UTF-8"
)
feed_document_id = document_response.parse["feedDocumentId"]
upload_url = document_response.parse["url"]

# Upload feed content
feed_content = File.read("inventory_update.xml")
api.upload_feed_document(upload_url, feed_content, "text/xml; charset=UTF-8")

# Create feed
feed_response = api.create_feed(
  feedType: "POST_INVENTORY_AVAILABILITY_DATA",
  marketplaceIds: ["ATVPDKIKX0DER"],
  inputFeedDocumentId: feed_document_id
)
feed_id = feed_response.parse["feedId"]
```

#### Reports API (2021-06-30)

Request and download reports about orders, inventory, fulfillment, and more.

```ruby
api = Peddler.reports_2021_06_30(aws_region, access_token)

# Request a report
create_response = api.create_report(
  reportType: "GET_FLAT_FILE_OPEN_LISTINGS_DATA",
  marketplaceIds: ["ATVPDKIKX0DER"]
)
report_id = create_response.parse["reportId"]

# Check report status
report = api.get_report(report_id).parse

# Once processed, get the document
if report["processingStatus"] == "DONE"
  doc_id = report["reportDocumentId"]
  document = api.get_report_document(doc_id).parse
  download_url = document["url"]
  # Download report from URL
end
```

#### Listings APIs

Manage product listings with multiple APIs:

- **Listings Items API (2021-08-01, 2020-09-01)**: Create and update listings
- **Listings Restrictions API (2021-08-01)**: Check listing eligibility
- **Product Type Definitions API (2020-09-01)**: Get schema requirements for listings

```ruby
api = Peddler.listings_items_2021_08_01(aws_region, access_token)
api.put_listings_item(
  seller_id,
  "SKU123",
  "ATVPDKIKX0DER",
  body: {
    productType: "LUGGAGE",
    requirements: "LISTING",
    attributes: {
      title: [{ value: "Travel Backpack" }],
      manufacturer: [{ value: "Brand Name" }]
    }
  }
)
```

#### Fulfillment APIs

Manage inventory and fulfillment through FBA and merchant fulfillment:

- **Fulfillment Inbound API (2024-03-20, v0)**: Send inventory to FBA
- **Fulfillment Outbound API (2020-07-01)**: Create and track FBA orders
- **FBA Inventory API (v1)**: Manage FBA inventory quantities
- **Merchant Fulfillment API (v0)**: Create shipping labels for self-fulfilled orders

```ruby
# FBA outbound example
api = Peddler.fulfillment_outbound_2020_07_01(aws_region, access_token)
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

#### Financial APIs (2024-06-19, 2024-06-01, v0)

Get financial data including transaction details, payments, and refunds.

```ruby
api = Peddler.finances_v0(aws_region, access_token)
response = api.list_financial_events(
  posted_after: "2023-01-01T00:00:00Z"
)
financial_events = response.parse["FinancialEvents"]
```

#### Notifications API (v1)

Subscribe to notifications for various events like order updates and report processing.

```ruby
api = Peddler.notifications_v1(aws_region, access_token)
# Create destination
destination = api.create_destination(
  name: "MyEventQueue",
  resourceSpecification: {
    sqs: { arn: "arn:aws:sqs:us-east-1:123456789012:MyQueue" }
  }
)
destination_id = destination.parse["payload"]["destinationId"]

# Create subscription
api.create_subscription(
  notificationType: "ANY_OFFER_CHANGED",
  destinationId: destination_id,
  payloadVersion: "1"
)
```

#### Vendor APIs

APIs for vendors selling to Amazon:

- **Vendor Orders API (v1)**: Retrieve purchase orders
- **Vendor Direct Fulfillment APIs**: Manage orders, shipping, payments, and inventory
- **Vendor Shipments API (v1)**: Track vendor shipments
- **Vendor Invoices API (v1)**: Submit and track invoices

```ruby
api = Peddler.vendor_orders_v1(aws_region, access_token)
orders = api.get_purchase_orders(
  limit: 10,
  createdAfter: "2023-01-01T00:00:00Z"
).parse
```

#### Additional APIs

- **A+ Content API (2020-11-01)**: Create and manage enhanced marketing content
- **Authorization API (2023-11-30)**: Manage app authorization
- **Messaging API (v1)**: Send messages to customers
- **Product Fees API (v0)**: Retrieve fee estimates for products
- **Product Pricing API (2022-05-01, v0)**: Get pricing information
- **Sellers API (v1)**: Get seller account information and marketplace participation
- **Shipping APIs (v1, v2)**: Create shipments and purchase shipping labels
- **Solicitations API (v1)**: Request customer reviews
- **Tokens API (2021-03-01)**: Generate restricted data tokens for accessing PII
- **Uploads API (2020-11-01)**: Upload files for various SP-API operations

For a complete list of available APIs, refer to the [API models repository](https://github.com/amzn/selling-partner-api-models).

## TODO

- [ ] Code generate payload parsers
- [ ] Review and consider applying [these patches][patches]

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
[patches]: https://github.com/bizon/selling-partner-api-sdk/tree/master/codegen/patches
