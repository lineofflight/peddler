# Peddler

[![Build](https://github.com/hakanensari/peddler/workflows/build/badge.svg)][build]
[![Maintainability](https://api.codeclimate.com/v1/badges/281e6176048f3c0a1ed3/maintainability)][maintainability]
[![Test Coverage](https://api.codeclimate.com/v1/badges/281e6176048f3c0a1ed3/test_coverage)][test-coverage]

**Peddler** is a Ruby interface to the [Amazon Selling Partner API (SP-API)][docs-overview]. The SP-API enables Amazon sellers and vendors to programmatically access their data on orders, shipments, payments, and more.

To begin using the Amazon SP-API, you must [register as a developer][register-as-developer] and [register your application][register-application]. Once registered, [obtain your Login with Amazon (LWA) credentials on Amazon][view-credentials]. You'll use these to access data for your own seller account or retrieve data on behalf of others.

![Peddler](https://github.com/hakanensari/peddler/blob/main/images/peddler.jpg?raw=true)

## Installation

Add this line to your Gemfile.

```ruby
gem "peddler", "3.0.0.beta1"
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

### Authentication

A seller or vendor will [provide a refresh token][authorization] to access their data on Amazon. You'll use this to generate temporary access tokens to authenticate individual API requests. Here’s how you can request one in Peddler.

```ruby
access_token = Peddler::AccessToken.request(
  refresh_token: "<REFRESH_TOKEN>",
)
```

You can also request a token for grantless operations.

```ruby
access_token = Peddler::AccessToken.request(
  scope: "sellingpartnerapi::notifications",
)
```

Access tokens are valid for one hour. To optimize performance, cache the token and reuse it across calls instead of generating a new one each time.

If you haven’t set your LWA credentials as environment variables, you can pass them directly when requesting an access token:

```ruby
access_token = Peddler::AccessToken.request(
  client_id: "<YOUR_CLIENT_ID>",
  client_secret: "<YOUR_CLIENT_SECRET>",
  refresh_token: "<REFRESH_TOKEN>",
)
```

Understood! I've updated the code examples to use `response.parse` instead of `response.body` for more efficient data access.

---

### The APIs

Peddler provides a class for each API version under an eponymous namespace. Below is a list of the more important APIs, along with brief descriptions and code examples to help you get started.

#### Catalog Items API (2022-04-01)

Provides programmatic access to Amazon's catalog data, such as item titles, descriptions, and other product details.

**Example:**

```ruby
client = Peddler::API::CatalogItems20220401.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.get_catalog_item(
  marketplaceIds: ["ATVPDKIKX0DER"],
  asin: "B08N5WRWNW"
)
items = response.parse.dig("items")
```

#### Orders API (v0)

Allows you to retrieve order information, including order details, buyer information, and order items.

**Example:**

```ruby
client = Peddler::API::OrdersV0.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.get_orders(
  marketplaceIds: ["ATVPDKIKX0DER"],
  createdAfter: "2023-01-01T00:00:00Z"
)
orders = response.parse.dig("orders")
```

#### Feeds API (2021-06-30)

Enables you to upload data to Amazon for updating listings, prices, inventory, and more.

**Example:**

```ruby
client = Peddler::API::Feeds20210630.new("<AWS_REGION>", "<ACCESS_TOKEN>")
# Create a feed document to get an upload URL
response = client.create_feed_document(
  contentType: "text/xml; charset=UTF-8"
)
feed_document_id = response.parse["feedDocumentId"]
upload_url = response.parse["url"]

# Upload the feed content to the provided URL
feed_content = File.read("inventory_update.xml")
client.upload_feed_document(upload_url, feed_content)

# Create the feed
response = client.create_feed(
  feedType: "POST_INVENTORY_AVAILABILITY_DATA",
  marketplaceIds: ["ATVPDKIKX0DER"],
  inputFeedDocumentId: feed_document_id
)
feed_id = response.parse["feedId"]
```

#### Reports API (2021-06-30)

Allows you to request and download various reports, such as order and inventory reports.

**Example:**

```ruby
client = Peddler::API::Reports20210630.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.create_report(
  reportType: "GET_FLAT_FILE_OPEN_LISTINGS_DATA",
  marketplaceIds: ["ATVPDKIKX0DER"]
)
report_id = response.parse["reportId"]
```

#### Listings Items API (2021-08-01)

Enables you to manage your product listings on Amazon, including creating, updating, and deleting listings.

**Example:**

```ruby
client = Peddler::API::ListingsItems20210801.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.put_listings_item(
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
result = response.parse
```

#### Notifications API (v1)

Allows you to subscribe to notifications for specific events like order status updates or feed processing statuses.

**Example:**

```ruby
client = Peddler::API::NotificationsV1.new("<AWS_REGION>", "<ACCESS_TOKEN>")
# Create a destination
response = client.create_destination(
  name: "MySQSQueue",
  resourceSpecification: {
    sqs: {
      arn: "arn:aws:sqs:us-east-1:123456789012:MyQueue"
    }
  }
)
destination_id = response.parse["destinationId"]

# Create a subscription
response = client.create_subscription(
  notificationType: "ANY_OFFER_CHANGED",
  destinationId: destination_id
)
subscription = response.parse
```

#### Product Fees API (v0)

Provides information about fees that may be charged for selling products on Amazon.

**Example:**

```ruby
client = Peddler::API::ProductFeesV0.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.get_my_fees_estimate_for_sku(
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

**Example:**

```ruby
client = Peddler::API::FulfillmentOutbound20200701.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.create_fulfillment_order(
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
result = response.parse
```

#### Merchant Fulfillment API (v0)

Allows you to create shipping labels for orders using Amazon's negotiated shipping rates.

**Example:**

```ruby
client = Peddler::API::MerchantFulfillmentV0.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.get_eligible_shipping_services(
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

**Example:**

```ruby
client = Peddler::API::VendorOrders20211228.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.get_purchase_orders(
  shipToPartyId: "<PARTY_ID>",
  limit: 10,
  createdAfter: "2023-01-01T00:00:00Z"
)
purchase_orders = response.parse["purchaseOrders"]
```

#### Vendor Direct Fulfillment Shipping API (2021-12-28)

Enables vendors to manage shipping labels and shipping information for direct fulfillment orders.

**Example:**

```ruby
client = Peddler::API::VendorDirectFulfillmentShipping20211228.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.get_packing_slip(
  purchaseOrderNumber: "PO123456789"
)
packing_slip = response.parse
```

#### Vendor Direct Fulfillment Orders API (2021-12-28)

Allows vendors to receive orders for direct fulfillment and provide shipment confirmations.

**Example:**

```ruby
client = Peddler::API::VendorDirectFulfillmentOrders20211228.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.get_orders(
  createdAfter: "2023-01-01T00:00:00Z",
  limit: 10
)
orders = response.parse["orders"]
```

#### Vendor Direct Fulfillment Inventory API (2021-12-28)

Enables vendors to update inventory levels for direct fulfillment items.

**Example:**

```ruby
client = Peddler::API::VendorDirectFulfillmentInventory20211228.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.submit_inventory_update(
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
result = response.parse
```

#### Shipping API (v2)

Provides functionalities for purchasing shipping labels and tracking shipments.

**Example:**

```ruby
client = Peddler::API::ShippingV2.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.purchase_shipment(
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
shipment = response.parse
```

#### Token API (2021-03-01)

Allows you to create restricted data tokens to access personally identifiable information (PII) in specific API calls.

**Example:**

```ruby
client = Peddler::API::Tokens20210301.new("<AWS_REGION>", "<ACCESS_TOKEN>")
response = client.create_restricted_data_token(
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
orders_client = Peddler::API::Orders20211201.new("<AWS_REGION>", restricted_data_token)
response = orders_client.get_order(
  orderId: "123-1234567-1234567"
)
order_details = response.parse
```

#### Finances API (v0)

Provides information about financial events for your seller account, such as order payments, refunds, and fees.

**Example:**

```ruby
client = Peddler::API::FinancesV0.new
response = client.list_financial_events(
  postedAfter: "2023-01-01T00:00:00Z",
  maxResultsPerPage: 100
)
financial_events = response.parse["FinancialEvents"]
```

#### Sellers API (V1)

Provides information about seller's marketplaces and participation status.

**Example:**

```ruby
client = Peddler::API::SellersV1.new
response = client.get_marketplace_participations
participations = response.parse["payload"]
```

[build]: https://github.com/hakanensari/peddler/actions
[maintainability]: https://codeclimate.com/github/hakanensari/peddler/maintainability
[test-coverage]: https://codeclimate.com/github/hakanensari/peddler/test_coverage
[docs-overview]: https://developer.amazonservices.com/sp-api-docs/overview
[register-as-developer]: https://developer-docs.amazon.com/sp-api/docs/registering-as-a-developer
[register-application]: https://developer-docs.amazon.com/sp-api/docs/registering-your-application
[view-credentials]: https://developer-docs.amazon.com/sp-api/docs/viewing-your-application-information-and-credentials
[authorization]: https://developer-docs.amazon.com/sp-api/docs/authorizing-selling-partner-api-applications
