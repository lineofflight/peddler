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

Instantiate a client:

```ruby
client = MWS::Feeds::Client.new('GB')
```

#### Submit Feed

Submit a feed:

```ruby
client.submit_feed(xml, '_POST_PRODUCT_DATA_')
```

#### Feed Submission List

List past feed submissions:

```ruby
# See the API for all available parameters for this and other methods.
client.get_feed_submissions
```

List the next page of feed submissions:

```ruby
client.get_feed_submissions_by_next_token
```

#### Feed Submission Count

Get the feed submission count:

```ruby
client.get_feed_submission_count(submitted_from_date: 1.day.ago)
```

#### Feed Submission Result

Get the processing report for a submitted feed:

```ruby
client.feed_submission_result('123456')
```

#### Feed Submissions

Cancel one or more feed submissions:

```ruby
client.cancel_feed_submissions(submitted_to_date: 1.day.ago)
```

### Fulfillment Inbound Shipment

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::FulfillmentInboundShipment::Client.new('GB')
```

Pull requests are welcome!

### Fulfillment Inventory

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::FulfillmentInventory::Client.new('GB')
```

Pull requests are welcome!

### Fulfillment Outbound Shipment

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::FulfillmentOutboundShipment::Client.new('GB')
```

Pull requests are welcome!

### Off Amazon Payments

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::OffAmazonPayments::Client.new('GB')
```

Pull requests are welcome!

### Orders

With the MWS Orders API, you can list orders created or updated during a time
frame you specify or retrieve information about specific orders.

[API methods are available on the client][4].

Instantiate a client:

```ruby
client = MWS::Orders::Client.new('GB')
```

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

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::Products::Client.new('GB')
```

Pull requests are welcome!

### Recommendations

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::Recommendations::Client.new('GB')
```

Pull requests are welcome!

### Reports

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::Reports::Client.new('GB')
```

Pull requests are welcome!

### Sellers

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::Sellers::Client.new('GB')
```

Pull requests are welcome!

### Subscriptions

This API is not implemented yet. You can still use the raw client like so:

```ruby
client = MWS::Subscriptions::Client.new('GB')
```

Pull requests are welcome!

[1]: http://f.cl.ly/items/0W3V0A1Z110Q0x461b3H/mussels.jpeg
[2]: https://developer.amazonservices.com/gp/mws/docs.html
[3]: https://github.com/papercavalier/peddler/blob/master/lib/mws/feeds/client.rb
[4]: https://github.com/papercavalier/peddler/blob/master/lib/mws/orders/client.rb
