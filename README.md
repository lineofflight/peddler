# Peddler
[Peddler](http://snl.github.com/peddler/doc) is a Ruby wrapper to the Amazon Inventory management API.

    client = Peddler::Client.new :username => "foo@bar.com",
                                 :password => "secret",
                                 :region   => "us"
    batch = client.new_inventory_batch
    item = client.new_inventory_item :product_id => "1234567890",
                                     :price      => 100.00,
                                     :sku        => "SKU-123",
                                     :quantity   => 10
    batch << item
    batch.upload
