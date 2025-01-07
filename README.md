# Peddler

[![Build](https://github.com/hakanensari/peddler/workflows/build/badge.svg)][build]
[![Maintainability](https://api.codeclimate.com/v1/badges/281e6176048f3c0a1ed3/maintainability)][maintainability]
[![Test Coverage](https://api.codeclimate.com/v1/badges/281e6176048f3c0a1ed3/test_coverage)][test-coverage]

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

If you haven’t set your LWA credentials as environment variables, pass them directly when requesting the token.

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

Amazon’s Selling Partner API (SP-API) imposes [rate limits][rate-limits] on most operations. Peddler respects these limits and will automatically back off when throttled. You can override the default rate limit by passing a `:rate_limit` to the operation.

You can also provide an optional `:retries` argument when initializing an API to specify the number of retries if throttled. By default, this is set to 0, meaning no retries will be attempted. If set to a positive value, Peddler will retry the request that many times if throttled, backing off based on the specified rate limit.

**Note:** This functionality requires version 6 of the underlying [HTTP library][httprb]. As of writing, this is not released yet. To use rate limiting, point to their main branch on GitHub.

Example usage:

```ruby
api = Peddler.orders_v0(aws_region, access_token, retries: 3)
api.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "2023-01-01T00:00:00Z"
)
```

In this example, if the request to `get_orders` is throttled, Peddler will retry the request up to 3 times, backing off according to the rate limit specified by Amazon.

### The APIs

Peddler provides a class for each API version under an eponymous namespace. Below is a list of the more important APIs, along with brief descriptions and code examples to help you get started.

#### Catalog Items API (2022-04-01)

Provides programmatic access to Amazon's catalog data, such as item titles, descriptions, and other product details.

```ruby
api = Peddler.catalog_items_2022_04_01(aws_region, access_token)
response = api.get_catalog_item(
  marketplaceIds: ["ATVPDKIKX0DER"],
  asin: "B08N5WRWNW"
)
items = response.dig("items")
```

#### Orders API (v0)

Allows you to retrieve order information, including order details, buyer information, and order items.

```ruby
api = Peddler.orders_v0(aws_region, access_token)
response = api.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "2023-01-01T00:00:00Z"
)
response.dig("orders")
```

#### Feeds API (2021-06-30)

Enables you to upload data to Amazon for updating listings, prices, inventory, and more.

```ruby
api = Peddler.feeds_2021_06_30(aws_region, access_token)

# Create a feed document to get an upload URL
response = api.create_feed_document(
  contentType: "text/xml; charset=UTF-8"
)
feed_document_id = response.parse["feedDocumentId"]
upload_url = response.parse["url"]

# Upload the feed content to the provided URL
feed_content = File.read("inventory_update.xml")
api.upload_feed_document(upload_url, feed_content, "text/xml; charset=UTF-8")

# Create the feed
response = api.create_feed(
  feedType: "POST_INVENTORY_AVAILABILITY_DATA",
  marketplaceIds: ["ATVPDKIKX0DER"],
  inputFeedDocumentId: feed_document_id
)
response.parse["feedId"]
```

#### Reports API (2021-06-30)

Allows you to request and download various reports, such as order and inventory reports.

```ruby
api = Peddler.reports_2021_06_30(aws_region, access_token)
response = api.create_report(
  reportType: "GET_FLAT_FILE_OPEN_LISTINGS_DATA",
  marketplaceIds: ["ATVPDKIKX0DER"]
)
response.parse["reportId"]
```

#### Listings Items API (2021-08-01)

Enables you to manage your product listings on Amazon, including creating, updating, and deleting listings.

```ruby
api = Peddler.listings_items_2021_08_01(aws_region, access_token)
response = api.put_listings_item(
  "<SELLER_ID>",
  "SKU123",
  "ATVPDKIKX0DER",
  body: {
    productType: "PRODUCT",
    requirements: "LISTING",
    attributes: {
      title: [{ value: "New Product Title" }],
      description: [{ value: "Product description goes here." }],
      bullet_point: [{ value: "Feature 1" }, { value: "Feature 2" }],
      manufacturer: [{ value: "Your Brand" }]
    }
  }
)
response.parse
```

#### Notifications API (v1)

Allows you to subscribe to notifications for specific events like order status updates or feed processing statuses.

```ruby
api = Peddler.notifications_v1(aws_region, access_token)
# Create a destination
response = api.create_destination(
  name: "MySQSQueue",
  resourceSpecification: {
    sqs: {
      arn: "arn:aws:sqs:us-east-1:123456789012:MyQueue"
    }
  }
)
destination_id = response.parse["destinationId"]

# Create a subscription
response = api.create_subscription(
  notificationType: "ANY_OFFER_CHANGED",
  destinationId: destination_id
)
subscription = response.parse
```

#### Product Fees API (v0)

Provides information about fees that may be charged for selling products on Amazon.

```ruby
api = Peddler.product_fees_v0(aws_region, access_token)
response = api.get_my_fees_estimate_for_sku(
  sellerId: "<YOUR_SELLER_ID>",
  sku: "SKU123",
  body: {
    FeesEstimateRequest: {
      MarketplaceId: "ATVPDKIKX0DER",
      IsAmazonFulfilled: true,
      PriceToEstimateFees: {
        ListingPrice: {
          CurrencyCode: "USD",
          Amount: 25.00
        }
      }
    }
  }
)
fees_estimate = response.parse
```

#### Fulfillment Outbound API (2020-07-01)

Allows you to create and manage fulfillment orders using Amazon's fulfillment network.

```ruby
api = Peddler.fulfillment_outbound_2020_07_01(aws_region, access_token)
response = api.create_fulfillment_order(
  body: {
    sellerFulfillmentOrderId: "ORDER123",
    displayableOrderId: "ORDER123",
    displayableOrderDate: Time.now.iso8601,
    displayableOrderComment: "Thank you for your order!",
    shippingSpeedCategory: "Standard",
    destinationAddress: {
      name: "John Doe",
      addressLine1: "123 Main St",
      city: "Anytown",
      stateOrRegion: "NY",
      postalCode: "12345",
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
response.parse
```

#### Merchant Fulfillment API (v0)

Allows you to create shipping labels for orders using Amazon's negotiated shipping rates.

```ruby
api = Peddler.merchant_fulfillment_v0(aws_region, access_token)
response = api.get_eligible_shipping_services(
  body: {
    shipmentRequestDetails: {
      amazonOrderId: "ORDER123",
      itemList: [
        {
          orderItemId: "ITEM123",
          quantity: 1
        }
      ],
      shipFromAddress: {
        name: "Your Company",
        addressLine1: "123 Warehouse Ave",
        city: "Anytown",
        stateOrRegion: "NY",
        postalCode: "12345",
        countryCode: "US"
      },
      packageDimensions: {
        length: 10,
        width: 5,
        height: 8,
        unit: "INCHES"
      },
      weight: {
        value: 2,
        unit: "POUNDS"
      },
      shippingServiceOptions: {
        deliveryExperience: "DELIVERY_CONFIRMATION_WITHOUT_SIGNATURE",
        carrierWillPickUp: false
      }
    }
  }
)
shipping_services = response.parse["shippingServiceList"]
```

#### Vendor Orders API (2021-12-29)

Allows vendors to retrieve purchase orders and order details from Amazon.

```ruby
api = Peddler.vendor_orders_2021_12_28(aws_region, access_token)
response = api.get_purchase_orders(
  shipToPartyId: "<PARTY_ID>",
  limit: 10,
  createdAfter: "2023-01-01T00:00:00Z"
)
purchase_orders = response.parse["purchaseOrders"]
```

#### Vendor Direct Fulfillment Shipping API (2021-12-28)

Enables vendors to manage shipping labels and shipping information for direct fulfillment orders.

```ruby
api = Peddler.vendor_direct_fulfillment_shipping_2021_12_28(aws_region, access_token)
response = api.get_packing_slip(
  purchaseOrderNumber: "PO123456789"
)
response.parse
```

#### Vendor Direct Fulfillment Orders API (2021-12-28)

Allows vendors to receive orders for direct fulfillment and provide shipment confirmations.

```ruby
api = Peddler.vendor_direct_fulfillment_orders_2021_12_28(aws_region, access_token)
response = api.get_orders(
  createdAfter: "2023-01-01T00:00:00Z",
  limit: 10
)
response.parse["orders"]
```

#### Vendor Direct Fulfillment Inventory API (2021-12-28)

Enables vendors to update inventory levels for direct fulfillment items.

```ruby
api = Peddler.vendor_direct_fulfillment_inventory_2021_12_28(aws_region, access_token)
response = api.submit_inventory_update(
  body: {
    inventory: [
      {
        sellingParty: {
          partyId: "<PARTY_ID>"
        },
        warehouseId: "<WAREHOUSE_ID>",
        items: [
          {
            buyerProductIdentifier: "B08N5WRWNW",
            availableQuantity: {
              amount: 100,
              unitOfMeasure: "Each"
            }
          }
        ]
      }
    ]
  }
)
response.parse
```

#### Shipping API (v2)

Provides functionalities for purchasing shipping labels and tracking shipments.

```ruby
api = Peddler.shipping_v2(aws_region, access_token)
response = api.purchase_shipment(
  body: {
    clientReferenceId: "CLIENT_REF_123",
    shipTo: {
      name: "John Doe",
      addressLine1: "123 Main St",
      city: "Anytown",
      stateOrRegion: "NY",
      postalCode: "12345",
      countryCode: "US"
    },
    shipFrom: {
      name: "Your Company",
      addressLine1: "123 Warehouse Ave",
      city: "Anytown",
      stateOrRegion: "NY",
      postalCode: "12345",
      countryCode: "US"
    },
    packages: [
      {
        dimensions: {
          length: 10,
          width: 5,
          height: 8,
          unit: "IN"
        },
        weight: {
          value: 2,
          unit: "LB"
        }
      }
    ],
    serviceType: "Standard"
  }
)
response.parse
```

#### Token API (2021-03-01)

Allows you to create restricted data tokens to access personally identifiable information (PII) in specific API calls.

```ruby
api = Peddler.tokens_2021_03_01(aws_region, access_token)
response = api.create_restricted_data_token(
  body: {
    restrictedResources: [
      {
        method: "GET",
        path: "/orders/v0/orders/123-1234567-1234567",
        dataElements: ["buyerInfo", "shippingAddress"]
      }
    ]
  }
)
restricted_data_token = response.parse["restrictedDataToken"]

# Use the token in subsequent API calls
orders_api = Peddler.orders_2021_12_01("<AWS_REGION>", restricted_data_token)
response = orders_api.get_order(
  orderId: "123-1234567-1234567"
)
response.parse
```

#### Finances API (v0)

Provides information about financial events for your seller account, such as order payments, refunds, and fees.

```ruby
api = Peddler.finances_v0(aws_region, access_token)
response = api.list_financial_events(
  postedAfter: "2023-01-01T00:00:00Z",
  maxResultsPerPage: 100
)
response.parse
```

#### Sellers API (V1)

Provides information about seller's marketplaces and participation status.

```ruby
api = Peddler.sellers_v1(aws_region, access_token)
response = api.get_marketplace_participations
response.parse
```

## TODO

- [ ] Code generate payload parsers.
- [ ] Code generate the APIs section—descriptions and code examples—in this README here.
- [ ] Schedule code generation with GitHub Actions. Push new gem when models change.
- [ ] Review and consider applying [these patches][patches].

[build]: https://github.com/hakanensari/peddler/actions
[maintainability]: https://codeclimate.com/github/hakanensari/peddler/maintainability
[test-coverage]: https://codeclimate.com/github/hakanensari/peddler/test_coverage
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
