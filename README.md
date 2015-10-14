# Peddler

[![Build Status](https://travis-ci.org/hakanensari/peddler.svg)](https://travis-ci.org/hakanensari/peddler)
[![Code Climate](https://codeclimate.com/github/hakanensari/peddler/badges/gpa.svg)](https://codeclimate.com/github/hakanensari/peddler)
[![Coverage Status](https://coveralls.io/repos/hakanensari/peddler/badge.svg?branch=master)](https://coveralls.io/r/hakanensari/peddler?branch=master)

**Peddler** is a Ruby interface to the [Amazon MWS API](https://developer.amazonservices.com/), a collection of web services that help Amazon sellers programmatically exchange data on their listings, orders, payments, reports, and more.

To use Amazon MWS, you must have an eligible seller account and register for MWS. This applies to developers as well.

Some MWS API sections may require additional authorisation from Amazon.

![Peddler](http://f.cl.ly/items/1G1N0A0a0v3a3h241c1Q/peddler.jpg)

## Usage

Require the library.

```ruby
require "peddler"
```

Create a client. Peddler provides one for each MWS API under an eponymous namespace.

```ruby
client = MWS::Orders::Client.new

# or the shorthand
client = MWS.orders
```

Each client requires valid MWS credentials. You can set these globally in the shell.

```bash
export MWS_MARKETPLACE_ID=foo
export MWS_MERCHANT_ID=bar
export AWS_ACCESS_KEY_ID=baz
export AWS_SECRET_ACCESS_KEY=qux
```

You can now instantiate a client.

```ruby
client = MWS::Orders::Client.new
```

Alternatively, you can set some or all credentials when or after creating the client.

```ruby
client = MWS::Orders::Client.new(
  primary_marketplace_id: "foo",
  merchant_id: "bar",
  aws_access_key_id: "baz",
  aws_secret_access_key: "qux"
)
```

If you are creating a client for another seller, pass the latter's `MWSAuthToken` to the client.

```ruby
client.auth_token = "corge"
```

Once you have a client with valid credentials, you should be able to make requests to the API.

Peddler returns the response wrapped in a parser that handles both XML documents and flat files.

```ruby
parser = client.get_service_status
parser.parse # will return a Hash or CSV object
```

You can swap the default parser with a purpose-built one.

```ruby
MWS::Orders::Client.parser = MyParser
```

For a sample implementation, see my [MWS Orders](https://github.com/hakanensari/mws-orders) library.

Finally, you can handle network errors caused by throttling or other transient issues by defining an error handler.

```ruby
MWS::Orders::Client.on_error do |e|
  if e.response.status == 503
    logger.warn e.response.message
  end
end
```

Alternatively, rescue.

```ruby
begin
  client.some_method
rescue Excon::Errors::ServiceUnavailable => e
  logger.warn e.response.message
  retry
end
```

## The APIs

### Cart Information

With the MWS Cart Information API, you can retrieve shopping carts that your Amazon Webstore customers have created. The Cart Information API enables you to programmatically integrate Amazon Webstore cart information with your CRM systems, marketing applications, and other systems that require cart data.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/CartInformation/Client)

### Customer Information

With the MWS Customer Information API, you can retrieve information from the customer accounts of your Amazon Webstore customers. This customer information includes customer name, contact information, customer account type, and associated Amazon Webstore marketplaces. The Customer Information API enables you to programmatically integrate Amazon Webstore customer account information with your CRM systems, marketing applications, and other systems that require customer data.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/CustomerInformation/Client)

### Feeds

The MWS Feeds API lets you upload inventory and order data to Amazon. You can also use this API to get information about the processing of feeds.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Feeds/Client)

### Finances

The MWS Finances API enables you to obtain financial information relevant to your business with Amazon. You can obtain financial events for a given order, financial event group, or date range without having to wait until a statement period closes. You can also obtain financial event groups for a given date range.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Finances/Client)

### Fulfillment Inbound Shipment

With the MWS Fulfillment Inbound Shipment API, you can create and update inbound shipments of inventory in the Amazon Fulfillment Network. You can also also request lists of inbound shipments or inbound shipment items based on criteria that you specify.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/FulfillmentInboundShipment/Client)

### Fulfillment Inventory

The MWS Fulfillment Inventory API can help you stay up-to-date on the availability of your inventory in the Amazon Fulfillment Network. The Fulfillment Inventory API reports real-time availability information for your Amazon Fulfillment Network inventory regardless of whether you are selling your inventory on Amazon's retail web site or through other retail channels.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/FulfillmentInventory/Client)

### Fulfillment Outbound Shipment

The MWS Fulfillment Outbound Shipment API enables you to fulfill orders placed through channels other than Amazon's retail web site, using your inventory in the Amazon Fulfillment Network. You can request previews of potential fulfillment orders that return estimated shipping fees and shipping dates based on shipping speed. You can get detailed item-level, shipment-level, and order-level information for any existing fulfillment order that you specify. You can also request lists of existing fulfillment orders based on when they were fulfilled and by the fulfillment method associated with them.

Support for creating and cancelling fulfillment orders has been implemented, but the rest of the API is not supported yet.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/FulfillmentOutboundShipment/Client)

### Off Amazon Payments

The MWS Off-Amazon Payments API helps you to process payments for purchases made by buyers on your website using the Login and Pay with Amazon service. This API enables you to programmatically retrieve shipping and payment information provided by the buyer from their Amazon account. It allows you to authorize, capture, and refund payments, enabling a variety of payments scenarios.

You can switch the client to the sandbox environment:

```ruby
client = MWS.off_amazon_payments.sandbox
```

[Read more](http://www.rubydoc.info/gems/peddler/MWS/OffAmazonPayments/Client)

### Orders

With the MWS Orders API, you can list orders created or updated during a time frame you specify or retrieve information about specific orders.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Orders/Client)

### Products

The MWS Products API helps you get information to match your products to existing product listings on Amazon Marketplace websites and to make sourcing and pricing decisions for listing those products on Amazon Marketplace websites.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Products/Client)

### Recommendations

The Recommendations API enables you to programmatically retrieve Amazon Selling Coach recommendations by recommendation category. A recommendation is an actionable, timely, and personalized opportunity to increase your sales and performance.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Recommendations/Client)

### Reports

The Reports API lets you request reports about your inventory and orders.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Reports/Client)

### Sellers

The Sellers API lets sellers retrieve information about their seller account, such as the marketplaces they participate in.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Sellers/Client)

### Subscriptions

The Amazon MWS Subscriptions API section enables you to subscribe to receive notifications that are relevant to your business with Amazon. With the operations in the Subscriptions API section, you can register to receive important information from Amazon without having to poll the Amazon MWS service. Instead, the information is sent directly to you when an event occurs to which you are subscribed.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Subscriptions/Client)

### Webstore

With the Webstore API section of Amazon Marketplace Web Service (Amazon MWS), you can get “Email Me When Available” subscription information for items listed on your Amazon Webstore. The Webstore API section can help you plan your inventory replenishment cycle by enabling you to query for items that your customers subscribed to when they clicked the Email Me When Available button on your Webstore. The Webstore API section can also return information about the notifications that were sent to your customers when out-of-stock items came back in stock. This information, when combined with sales information that your Webstore tracks, can help you determine how many notifications were converted into sales.

[Read more](http://www.rubydoc.info/gems/peddler/MWS/Webstore/Client)
