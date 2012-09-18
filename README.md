# Peddler

[![travis][1]][2]

![Peddler][3]

Peddler wraps the [Amazon Marketplace Web Service (MWS) APIs][4].

```ruby
service = Peddler.new 'US'

service.configure key:    'key',
                  secret: 'secret',
                  seller: 'seller'

service.status # => "GREEN"
```

## Feeds

The Feeds API lets you upload inventory and order data to Amazon.

## Fulfillment Inbound Shipment

With the Fulfillment Inbound Shipment API, you can create and update inbound
shipments of inventory in the Amazon Fulfillment Network. You can also request
lists of inbound shipments or inbound shipment items based on criteria that you
specify.

## Fulfillment Inventory

The Fulfillment Inventory API lets you see what is available in your inventory.
It's a real-time reporting mechanism that returns your current or
recently-changed inventory supply in the Amazon fulfillment network.

## Fulfillment Outbound Shipment

The Fulfillment Outbound Shipment API is designed to help you integrate
Fulfillment by Amazon with any payment processing application or inventory
management system currently in use.

## Orders

The Orders API helps you build simple applications that retrieve only the order
information that you need.

## Products

The Products API helps you get information to match your products to existing
product listings on Amazon Marketplace websites and to make sourcing and
pricing decisions for listing those products on Amazon Marketplace websites.

## Reports

The Reports API lets you request reports about your inventory and orders.

## Sellers

The Sellers API lets sellers retrieve information about their seller account,
such as the marketplaces they participate in.

[1]: https://secure.travis-ci.org/papercavalier/peddler.png
[2]: http://travis-ci.org/papercavalier/peddler
[3]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[4]: https://developer.amazonservices.com/gp/mws/docs.html
