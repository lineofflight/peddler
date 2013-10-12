# Peddler

[![Build Status][travis]][badge]

![Peddler][mussels]

**Peddler** is a full-featured Ruby interface to the [Amazon Marketplace Web Service (MWS) APIs][docs].

## Configuration

Require the library:

```ruby
require 'peddler'
```

Or require an individual API:

```ruby
require 'mws/orders'
```

Instantiate a client to a particular API with the ISO 3166-1 two-letter country code of the marketplace and your seller credentials:

```ruby
client = MWS::Orders::Client.new('GB', 'key', 'secret', 'merchant_id')
```

You may also set the credentials as environment variables in your shell:

```sh
export AWS_ACCESS_KEY_ID=key
export AWS_SECRET_ACCESS_KEY=secret
export MERCHANT_ID=merchant_id
```

Then, instantiate with the country code:

```ruby
client = MWS::Orders::Client.new('US')
```

When developing, you may set the `EXCON_DEBUG` environment variable to debug the HTTP exchange.

## Usage

### Feeds

The MWS Feeds API lets you upload inventory and order data to Amazon. You can also use this API to get information about the processing of feeds.

[Read the client API methods.][feeds-api]

### Fulfillment Inbound Shipment

With the Fulfillment Inbound Shipment API, you can create and update inbound shipments of inventory in the Amazon Fulfillment Network. You can also request lists of inbound shipments or inbound shipment items based on criteria that you specify.

While this API is not implemented yet, you may still use the raw client like so:

```ruby
client = MWS::FulfillmentInboundShipment::Client.new('GB')
```

Pull requests are welcome!

### Fulfillment Inventory

The Fulfillment Inventory API lets you see what is available in your inventory. It's a real-time reporting mechanism that returns your current or recently-changed inventory supply in the Amazon fulfillment network.

While this API is not implemented yet, you may still use the raw client like so:

```ruby
client = MWS::FulfillmentInventory::Client.new('GB')
```

Pull requests are welcome!

### Fulfillment Outbound Shipment

The Fulfillment Outbound Shipment API is designed to help you integrate Fulfillment by Amazon with any payment processing application or inventory management system currently in use.

While this API is not implemented yet, you may still use the raw client like so:

```ruby
client = MWS::FulfillmentOutboundShipment::Client.new('GB')
```

Pull requests are welcome!

### Off Amazon Payments

While this API is not implemented yet, you may still use the raw client like so:

```ruby
client = MWS::OffAmazonPayments::Client.new('GB')
```

Pull requests are welcome!

### Orders

With the MWS Orders API, you can list orders created or updated during a time frame you specify or retrieve information about specific orders.

[Read the client API methods.][orders-api]

### Products

The Products API helps you get information to match your products to existing product listings on Amazon Marketplace websites and to make sourcing and pricing decisions for listing those products on Amazon Marketplace websites.

While this API is not implemented yet, you may still use the raw client like so:

```ruby
client = MWS::Products::Client.new('GB')
```

Pull requests are welcome!

### Recommendations

While this API is not implemented yet, you may still use the raw client like so:

```ruby
client = MWS::Recommendations::Client.new('GB')
```

Pull requests are welcome!

### Reports

The Reports API lets you request reports about your inventory and orders.

[Read the client API methods.][reports-api]

### Sellers

The Sellers API lets sellers retrieve information about their seller account, such as the marketplaces they participate in.

[Read the client API methods.][sellers-api]

### Subscriptions

While this API is not implemented yet, you may still use the raw client like so:

```ruby
client = MWS::Subscriptions::Client.new('GB')
```

Pull requests are welcome!

[travis]: https://travis-ci.org/papercavalier/peddler.png
[badge]:https://travis-ci.org/papercavalier/peddler
[mussels]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[docs]: https://developer.amazonservices.com/gp/mws/docs.html
[feeds-api]: https://github.com/papercavalier/peddler/blob/master/lib/mws/feeds/client.rb
[orders-api]: https://github.com/papercavalier/peddler/blob/master/lib/mws/orders/client.rb
[reports-api]: https://github.com/papercavalier/peddler/blob/master/lib/mws/orders/client.rb
[sellers-api]: https://github.com/papercavalier/peddler/blob/master/lib/mws/sellers/client.rb
