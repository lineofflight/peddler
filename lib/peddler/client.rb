# = Peddler
# Peddler is a Ruby wrapper to the {Amazon Inventory management API}[https://images-na.ssl-images-amazon.com/images/G/01/Amazon_AIM/Amazon_AIM.pdf].
# 
# Peddler::Client contains some detailed explanation and examples of usage.
module Peddler
  # This is the public interface of the Peddler library.
  class Client
    # Creates a client.
    #
    #    client = Peddler::Client.new(
    #      :username => 'foo@bar.com',
    #      :password => 'secret',
    #      :region   => :us
    #    )
    #
    # Alternatively, set attributes after creating the client:
    #
    #    client = Peddler::Client.new
    #    client.username = 'foo@bar.co.uk'
    #    client.password = 'tad_more_secret'
    #    client.region   = 'uk'
    #
    def initialize(params={})
      [:username=, :password=, :region=].each do |method|
        self.class.send(:define_method, method, lambda { |value| transport.send(method, value) })
      end
      params.each_pair { |k, v| self.send("#{k}=", v) }
    end
    
    # Creates an inventory batch.
    #
    #    batch = client.new_inventory_batch
    #    book = new_inventory_item(
    #      :product_id => '1234567890',
    #      :sku        => 'SKU-001',
    #      :price      => 10.00,
    #      :quantity   => 1)
    #    batch << book
    #    batch.upload
    #
    # Once the batch is processed, you may view the report:
    #
    #    report = client.new_report :upload, :id => batch.id
    #    p report.body
    #    => "Feed Processing Summary:\n\tNumber of records processed\t\t1\n\tNumber of records successful\t\t1\n\n"
    #
    def new_inventory_batch
      Peddler::Inventory::Batch.new(transport.dup)
    end
    
    # A short-hand method to purge inventory.
    #
    #    client.purge_inventory
    #
    def purge_inventory
      empty_batch = Peddler::Inventory::Batch.new(transport.dup)
      empty_batch.upload(:method => 'purge')
      
    end
    
    # Creates an inventory item. Parameter keys are lowercased and underscored but otherwise the same as
    # the colum titles in the tab-delimited upload templates provided by Amazon.
    def new_inventory_item(params={})
      Peddler::Inventory::Item.new(params)
    end
    
    # Returns count of pending inventory uploads queued at Amazon.
    def inventory_queue
      Peddler::Inventory::Queue.count(transport)
    end
    
    # Creates an order fulfillment batch.
    #
    #    feed = client.new_order_fulfillment_feed
    #    fulfilled_order = client.new_fulfilled_order(
    #      :order_id    => "123-1234567-1234567",
    #      :order_date  => "2009-08-01")
    #    feed << fulfilled_order
    #    feed.upload
    #    feed.status
    #    => "_SUBMITTED_"
    #    sleep(60)
    #    feed.status!
    #    => "_DONE_"
    #    p feed.download.to_s
    #
    def new_order_fulfillment_feed
      Peddler::Feeds::OrderFulfillment::Batch.new(transport.dup)
    end
    
    # Creates an item that can then be added to an order fulfillment feed. Keys are lowercased and underscored but
    # otherwise the same as Amazon's headers. See section 7.1 in the API docs.
    def new_fulfilled_order(params={})
      Peddler::Feeds::OrderFulfillment::Item.new(params)
    end
    
    # Creates an order cancellation batch.
    #
    #    feed = client.new_order_cancellation_feed
    #    cancelled_order = client.new_cancelled_order(
    #      :order_id    => "123-1234567-1234567",
    #      :cancellation_reason_code => "NoInventory",
		#      :amazon_order_item_code => "12341234567890")
    #    feed << cancelled_order
    #    feed.upload
    #    feed.status
    #    => "_SUBMITTED_"
    #    sleep(60)
    #    feed.status!
    #    => "_DONE_"
    #    p feed.download.to_s
    #
    def new_order_cancellation_feed
      Peddler::Feeds::OrderCancellation::Batch.new(transport.dup)
    end
    
    # Creates an item that can then be added to an order cancellation feed. Keys are lowercased and underscored but
    # otherwise the same as Amazon's headers. See section 7.4 in the API docs.
    def new_cancelled_order(params={})
      Peddler::Feeds::OrderCancellation::Item.new(params)
    end
    
    # Creates a refund batch.
    #
    #    batch = client.new_refund_batch
    #    refund = client.new_refund(
    #      :order_id                 => "123-1234567-1234567",
    #      :payments_transaction_id  => "12341234567890",
    #      :refund_amount            => 10.00,
    #      :reason                   => "CouldNotShip",
    #      :message                  => "With our apologies.")
    #    batch << refund
    #    batch.upload
    #    sleep(60)
    #    status = client.latest_reports :batch_refund, :count => 1
    #    report = client.new_report(
    #      :batch_refund,
    #      :id => status[0].id)
    #    p report.body
    #    => "123-1234567-1234567order-item-id: 12341234567890\tSUCCESS 10.00 is Refunded.\r\n"
    #
    def new_refund_batch
      Peddler::Refunds::Batch.new(transport.dup)
    end
    
    # Creates a refund item that can then be added to a refund batch.
    #
    # Possible reasons: ["GeneralAdjustment", "CouldNotShip", "DifferentItem", "MerchandiseNotReceived", "MerchandiseNotAsDescribed"]
    def new_refund(params={})
      Peddler::Refunds::Item.new(params)
    end
    
    # Creates an instance for an already-generated report. Works only with 
    # legacy reports, meaning anything that comes before section 7 in the API
    # docs.
    #
    # Possible report names: [:upload, :order, :preorder, :batch_refund,
    # :open_listings, :open_listings_lite, :open_listings_liter]
    #
    # You can download a specific report by using its ID. Otherwise, the 
    # instance will fetch the latest available report. One oddball exception: 
    # Upload reports do require an ID and will return nil if you don't provide
    # one.
    # 
    #    orders_report = client.new_report :order
    #    orders = client.detab(orders_report.body)
    #    orders[0].buyer_name
    #    => "John Doe"
    #
    #    preorders_report = client.new_report(
    #      :preorder,
    #      :product_line  => "Books",
    #      :frequency     => 2)
    #    preorders = client.detab(preorders_report.body)
    #    preorders[0].average_asking_price
    #    => "100"
    # 
    def new_report(name,params={})
      Peddler::LegacyReports::Report.new(transport.dup, name, params)
    end
    
    # Requests a report. Returns true when successful.
    #
    # Possible report names: [:order, :open_listings, :open_listings_lite, :open_listings_liter]
    #
    #    client.generate_report :order, :number_of_days => 15
    #
    # A word of caution. Open listings may crap up with larger inventories.
    def generate_report(name,params={})
      Peddler::LegacyReports.generate(transport, name, params)
    end
    
    # Creates an unshipped order report. Takes on some optional parameters, such as :id, :starts_at, :ends_at. By default,
    # it will request a new unshipped order report for the past seven days.
    #
    #    report = client.new_unshipped_orders_report
    #    report.status
    #    => "_SUBMITTED_"
    #    sleep(60)
    #    report.status!
    #    => "_DONE_"
    #    p report.unshipped_orders
    #   
    def new_unshipped_orders_report(params={})
      Peddler::Reports::UnshippedOrdersReport.new(transport.dup, params)
    end
    
    # Returns status of most recent reports. Optional "count" defaults to 10. Name can be [ :upload, :order, :batch_refund, :open_listings, :open_listings_lite, :open_listings_liter ].
    #
    #    reports = client.latest_reports :order, :count => 1
    #    reports[0]
    #    => #<Peddler::LegacyReports::ReportStatus starts_at="07-29-2009:10-00-06" ... 
    #
    def latest_reports(name,params={})
      Peddler::LegacyReports.latest(transport, name, params)
    end
    
    # Decodes tab-delimited content into an array of OpenStruct objects.
    def detab(msg)
      Peddler::Handlers::TabDelimitedHandler.decode_response(msg)
    end
    
    private
    
    def transport #:nodoc:all
      @transport ||= Peddler::Transport.new
    end
  end
end
