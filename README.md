# Peddler

[![Build](https://github.com/hakanensari/peddler/workflows/build/badge.svg)](https://github.com/hakanensari/peddler/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/281e6176048f3c0a1ed3/maintainability)](https://codeclimate.com/github/hakanensari/peddler/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/281e6176048f3c0a1ed3/test_coverage)](https://codeclimate.com/github/hakanensari/peddler/test_coverage)

> :boom: Amazon is migrating to the newly-launched Selling Partner API (SP-API) and is no longer granting new users access to the MWS APIs. I hope to add support in Peddler in due course.

**Peddler** is a Ruby interface to the [Amazon MWS API](https://developer.amazonservices.com/), a collection of web services that help Amazon sellers programmatically exchange data on their listings, orders, payments, reports, and more.

To use Amazon MWS, you must have an eligible seller account and [register as a developer](https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Registering.html#DG_Registering__RegisteringAsADeveloper). You can then access your own selling account using its merchant ID—note that Amazon also refers to this as seller ID or merchant token in different places.

Amazon has [multiple regions](https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Endpoints.html). Each region requires application developers to register individually. Some MWS API sections may require additional authorisation from Amazon.

![Peddler](https://github.com/hakanensari/peddler/blob/main/images/peddler.jpg?raw=true)

## Usage

Require the library.

```ruby
require "peddler"
```

A client requires the AWS credentials of the application developer. If you are working in a single MWS region, you can set them globally.


```bash
export AWS_ACCESS_KEY_ID=YOUR_AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_ACCESS_KEY
```

Now, create a client with the Amazon marketplace you signed up on and a merchant ID. Peddler provides a class for each API section under an eponymous namespace.

```ruby
client = MWS.orders(marketplace: "ATVPDKIKX0DER",
                    merchant_id: "123")

# or a shorthand
client = MWS.orders(marketplace: "US",
                    merchant_id: "123")
```

If you are creating a [client for another seller](https://developer.amazonservices.com/gp/mws/faq.html#developForSeller), pass an MWS Auth Token as well.

```ruby
client = MWS.orders(marketplace: "ATVPDKIKX0DER",
                    merchant_id: "123",
                    auth_token: "123")
```

You won't be able to create a client for another seller if you are in different regions.

If you are working with sellers across multiple regions, a single set of credentials will not be enough. In that case, do not use global environment variables and pass your AWS credentials when creating the client.

```ruby
client = MWS.orders(marketplace: "ATVPDKIKX0DER",
                    merchant_id: "123",
                    aws_access_key_id: "123",
                    aws_secret_access_key: "123")
```

Once you have a client with valid credentials, you should be able to make requests to the API. Clients map operation names in a flat structure. Methods have positional arguments for required input and keyword arguments for optional parameters. Both method and argument names are underscored but otherwise identical to the names of the corresponding operations and parameters documented in the API.

For instance, using the above MWS Orders client:

```ruby
response = client.list_orders('ATVPDKIKX0DER')
```

### Parser

Peddler wraps successful responses in a generic parser that handles both XML documents and flat files:

```ruby
response = client.get_service_status
response.parse # will return a Hash object
response.dig('Status') # delegates to Hash#dig
```

You can swap this with a purpose-built parser.

```ruby
MWS::Orders::Client.parser = MyParser
```

For a sample implementation, see my [MWS Orders](https://github.com/hakanensari/mws-orders) library.

### Throttling

Amazon limits the number of requests you can submit to some operations in a given amount of time. When you hit a limit, your request throws a `Peddler::Errors::RequestThrottled` error.

You will want to exit or back off exponentially and retry if you hit this error.

```ruby
begin
  client.throttled_method
rescue Peddler::Errors::RequestThrottled
  back_off_exponentially
  retry
end
```

Some API sections also have an hourly request quota in addition to the numerical request quota. When you hit this quota, your request throws a `Peddler::Errors::QuotaExceeded` error.

You can introspect your quota usage on the parsed response:

```ruby
response = client.method_with_quota
puts response.mws_quota_remaining
# 150

begin
  client.method_with_quota
rescue Peddler::Errors::QuotaExceeded => error
  puts error.response.mws_quota_remaining
  # 0
end
```

Read [tips on how to avoid throttling](https://docs.developer.amazonservices.com/en_US/dev_guide/DG_Throttling.html).

### Debugging

If you are having trouble with a request, read the [Amazon documentation](https://developer.amazonservices.com/gp/mws/docs.html). [Peddler's source](https://www.rubydoc.info/github/hakanensari/peddler) also links individual operations to their corresponding entries in the Amazon docs.

Note that some optional keywords have default values.

To introspect requests, set the `EXCON_DEBUG` environment variable to `1` or similar truthy value. Peddler will then log request and response internals to stdout.

If you contact Amazon MWS support, they will ask you for the **RequestId** and **Timestamp** of affected requests.

```ruby
response = client.problem_method
puts response.mws_request_id
puts response.mws_timestamp
```

You can access the same attributes on `error.response`. See <a href="#throttling">above example</a>.

## The APIs

### Easy Ship

With the Easy Ship API, you can build applications that help sellers in India manage and ship their Amazon Easy Ship orders. Your Amazon Easy Ship applications can get available pickup slots; schedule, reschedule, and cancel pickups; and print labels, invoices, and warranties.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/easy_ship/EasyShip_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/EasyShip/Client)

### Feeds

The MWS Feeds API lets you upload inventory and order data to Amazon. You can also use this API to get information about the processing of feeds.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/feeds/Feeds_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Feeds/Client)
- [XML schema docs](https://sellercentral.amazon.com/gp/help/help-page.html?itemID=1611)

### Finances

The MWS Finances API enables you to obtain financial information relevant to your business with Amazon. You can obtain financial events for a given order, financial event group, or date range without having to wait until a statement period closes. You can also obtain financial event groups for a given date range.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/finances/Finances_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Finances/Client)

### Fulfillment Inbound Shipment

With the MWS Fulfillment Inbound Shipment API, you can create and update inbound shipments of inventory in the Amazon Fulfillment Network. You can also also request lists of inbound shipments or inbound shipment items based on criteria that you specify.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/fba_inbound/FBAInbound_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/FulfillmentInboundShipment/Client)

### Fulfillment Inventory

The MWS Fulfillment Inventory API can help you stay up-to-date on the availability of your inventory in the Amazon Fulfillment Network. The Fulfillment Inventory API reports real-time availability information for your Amazon Fulfillment Network inventory regardless of whether you are selling your inventory on Amazon's retail web site or through other retail channels.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/fba_inventory/FBAInventory_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/FulfillmentInventory/Client)

### Fulfillment Outbound Shipment

The MWS Fulfillment Outbound Shipment API enables you to fulfill orders placed through channels other than Amazon's retail web site, using your inventory in the Amazon Fulfillment Network. You can request previews of potential fulfillment orders that return estimated shipping fees and shipping dates based on shipping speed. You can get detailed item-level, shipment-level, and order-level information for any existing fulfillment order that you specify. You can also request lists of existing fulfillment orders based on when they were fulfilled and by the fulfillment method associated with them.

Support for creating and cancelling fulfillment orders has been implemented, but the rest of the API is not supported yet.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/fba_outbound/FBAOutbound_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/FulfillmentOutboundShipment/Client)

### Merchant Fulfillment

The Merchant Fulfillment API provides programmatic access to Amazon’s fulfillment shipping services for sellers, including competitive rates with Amazon-partnered carriers. Sellers can find out what shipping services are available by submitting information about a proposed fulfillment shipment, such as package size and weight; shipment origin and destination; and delivery date requirements. Sellers can choose from the shipping service options returned by Amazon, and then receive shipping labels for fulfilling their orders.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/merch_fulfill/MerchFulfill_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/MerchantFulfillment/Client)

### Orders

With the MWS Orders API, you can list orders created or updated during a time frame you specify or retrieve information about specific orders.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/orders-2013-09-01/Orders_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Orders/Client)

### Products

The MWS Products API helps you get information to match your products to existing product listings on Amazon Marketplace websites and to make sourcing and pricing decisions for listing those products on Amazon Marketplace websites.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/products/Products_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Products/Client)

### Recommendations

The Recommendations API enables you to programmatically retrieve Amazon Selling Coach recommendations by recommendation category. A recommendation is an actionable, timely, and personalized opportunity to increase your sales and performance.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/recommendations/Recommendations_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Recommendations/Client)

### Reports

The Reports API lets you request reports about your inventory and orders.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/reports/Reports_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Reports/Client)

### Sellers

The Sellers API lets sellers retrieve information about their seller account, such as the marketplaces they participate in.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Sellers/Client)

### Shipment Invoicing

With the Shipment Invoicing API section (in conjunction with the FBAOutboundShipmentStatus notification), you can integrate invoicing into Amazon’s shipping process for a seller’s Fulfillment by Amazon (FBA) orders.

This functionality is available only in the Brazil marketplace.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/shipment_invoicing/ShipmentInvoicing_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/ShipmentInvoicing/Client)

### Subscriptions

The Amazon MWS Subscriptions API section enables you to subscribe to receive notifications that are relevant to your business with Amazon. With the operations in the Subscriptions API section, you can register to receive important information from Amazon without having to poll the Amazon MWS service. Instead, the information is sent directly to you when an event occurs to which you are subscribed.

- [Amazon references](https://docs.developer.amazonservices.com/en_US/subscriptions/Subscriptions_Overview.html)
- [Peddler API docs](https://www.rubydoc.info/github/hakanensari/peddler/MWS/Subscriptions/Client)
