# Peddler

![Peddler][1]

**Peddler** is a full-featured Ruby interface to the [Amazon Marketplace Web
Service (MWS) APIs][2].

## Usage

Require the library:

```ruby
require 'peddler'
```

Alternatively, require a particular API only:

```ruby
require 'mws/orders'
```

Instantiate a client with the ISO 3166-1 two-letter country code of the
marketplace and your seller credentials:

```ruby
client = MWS::Orders::Client.new('GB', 'key', 'secret', 'merchant_id')
```

Alternatively, set your credentials as environment variables in your shell:

```sh
export AWS_ACCESS_KEY_ID=key
export AWS_SECRET_ACCESS_KEY=secret
export MERCHANT_ID=merchant_id
```

Then, instantiate with the country code:

```ruby
client = MWS::Orders::Client.new('US')
```

### Feeds

The MWS Feeds API lets you upload inventory and order data to Amazon. You can
also use this API to get information about the processing of feeds.

[API methods are available on the client][3].

### Fulfillment Inbound Shipment

Not implemented.

### Fulfillment Inventory

Not implemented.

### Fulfillment Outbound Shipment

Not implemented.

### Off Amazon Payments

Not implemented.

### Orders

With the MWS Orders API, you can list orders created or updated during a time
frame you specify or retrieve information about specific orders.

[API methods are available on the client][4].

#### Orders

List orders:

```ruby
# See the API for all available parameters.
client.list_orders(
  created_after: 1.week.ago,
  order_status: %w(Pending Unshipped)
)
```

List the next page of orders:

```ruby
client.list_orders_by_next_token
```

Get one or more orders based on their order numbers:

```ruby
client.get_order('123-1234567-1234567')
```

All above queries will return an enumerable list of orders.

#### Order Items

List order items based on an order number you specify:

```ruby
client.list_order_items('123-1234567-1234567')
```

List the next page of order items:

```ruby
client.list_order_items_by_next_token
```

All above queries will return an enumerable list of order items.

#### Service Status

Check the operational status of the API:

```ruby
client.get_service_status
```

### Products

Not implemented.

### Recommendations

Not implemented.

### Reports

Not implemented.

### Sellers

Not implemented.

### Subscriptions

Not implemented.

[1]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[2]: https://developer.amazonservices.com/gp/mws/docs.html
[3]: https://github.com/papercavalier/peddler/blob/master/lib/mws/feeds/client.rb
[4]: https://github.com/papercavalier/peddler/blob/master/lib/mws/orders/client.rb
