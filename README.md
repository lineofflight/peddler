Peddler
=======

Peddler is a Ruby wrapper to the Amazon Inventory management API.

![Peddler](https://github.com/papercavalier/peddler/raw/master/mussels.jpg)

Example usage
-------------

Set up a client:

    client = Peddler::Client.new(
      :username => 'foo@bar.com',
      :password => 'secret',
      :region   => :us)

Create an inventory file:

    batch = client.new_inventory_batch
    item = client.new_inventory_item(
      :product_id => '1234567890',
      :price      => 100.00,
      :sku        => 'SKU-123',
      :quantity   => 10)
    batch << item

Repeat ad infinitum and upload:

    batch.upload

The batch now should have an upload ID. Now, check the error log:

    upload_log = client.new_report(
      :upload,
      :id => batch.id)
    upload_log.body
    => "Feed Processing Summary:\n\tNumber of records processed\t\t1\n\tNumber of records successful\t\t1\n\n"

You are wondering if you have any new orders:

    orders_report = client.new_report :order
    orders = client.detab(orders_report.body)
    p orders.size
    => 1500
    p orders[0].item_name
    => "A Thousand Plateaus: Capitalism and Schizophrenia (Paperback) by Gilles Deleuze"

After processing the orders, post back the results to Amazon:

    feed = client.new_order_fulfillment_feed
    fulfilled_order = client.new_fulfilled_order(
      :order_id         => '123-1234567-1234567',
      :order_date       => '2009-08-01',
      :carrier_code     => 'USPS',
      :tracking_number  => '0308 0330 0000 0000 0000')
    feed << fulfilled_order

Once done, upload:

    feed.upload

Want to see the processing report?

    p feed.status
    => "_SUBMITTED_"

Refresh until you get:

    p feed.status!
    => "_DONE_"

Then, check the report:

    p feed.download.to_s

You have an order you can't fill and haven't shipped yet. No problem:

    feed = client.new_order_cancellation_feed
    cancelled_order = client.new_cancelled_order(
      :order_id                 => '123-1234567-1234567',
      :cancellation_reason_code => 'NoInventory',
      :amazon_order_item_code   => '12341234567890')
    feed << cancelled_order
    feed.upload
    sleep(60)
    feed.status!
    => "_DONE_"  
    p feed.download.to_s
    => ...

To post a refund for an already-shipped item, you use the batch refund method:

    refunds = client.new_refund_batch
    refund = client.new_refund(
      :order_id                 => '123-1234567-1234567',
      :payments_transaction_id  => '12341234567890',
      :refund_amount            => 1.00,
      :reason                   => 'GeneralAdjustment',
      :message                  => 'With our apologies.')
    refunds << refund
    refunds.upload

For a change, let's download something different from Amazon, like a preorder report:

    preorder_report = client.new_report(
      :preorder,
      :product_line => 'Books',
      :frequency    => 2)
    preorders = client.detab(preorder_report.body)
    p preorders.size
    => 2000
    p preorders[0].asin
    => "1234567890"
    p preorders[0].average_asking_price
    => "100"

[Read source](http://gloss.papercavalier.com/peddler) for more info.

Todo
----

Switch to using the [Amazon Marketplace Web Service (Amazon MWS)](https://mws.amazon.com/index.html).

Compatibility
-------------

Specs pass against Ruby 1.8.7, Ruby 1.9.2, and Rubinius 1.1.
