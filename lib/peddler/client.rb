# = Peddler
# The affectionately-named Peddler is a Ruby wrapper to the Amazon Inventory management API. It supports all the functionality, new and old, provided by the API.
# 
# Peddler::Client has some detailed explanation and examples of usage.
module Peddler
  # This is the public interface of the Peddler library.
  class Client
    # Creates a client instance.
    #
    #   client = Peddler::Client.new :username => "foo@bar.com",
    #                                :password => "secret",
    #                                :region => "us"
    #
    def initialize(params={})
      params.each_pair { |key, value| self.send("#{key}=", value) }
    end
    
    def username=(username)
      self.transport.username = username
    end
    
    def password=(password)
      self.transport.password = password
    end
    
    # Sets Amazon region. Works with [ "us", "uk", "de", "ca", "fr", "jp" ].
    def region=(region)
      self.transport.region = region
    end
    
    # Creates an inventory batch.
    #
    # A sample workflow:
    #
    #   batch = client.new_inventory_batch
    #   book = new_inventory_item :product_id => "1234567890",
    #                             :sku        => "SKU-001",
    #                             :price      => 10.00,
    #                             :quantity   => 1
    #   batch << book
    #   batch.upload
    #
    # The batch should now have an upload id assigned to it by Amazon. Once processed, you can use this to 
    # check the error log:
    #
    #    report = client.new_report :upload, :id => batch.id
    #    report.body
    #
    # That should output something like the following, assuming everything went well with the upload:
    #
    #    "Feed Processing Summary:\n\tNumber of records processed\t\t1\n\tNumber of records successful\t\t1\n\n"
    #
    def new_inventory_batch
      Peddler::Inventory::Batch.new(self.transport.dup)
    end
    
    # Creates an inventory item. Parameter keys are lowercased and underscored but otherwise the same as
    # Amazon's colum titles in their tab-delimited templates.
    def new_inventory_item(params={})
      Peddler::Inventory::Item.new(params)
    end
    
    # Returns count of pending inventory uploads queued at Amazon.
    def inventory_queue
      Peddler::Inventory::Queue.count(self.transport)
    end
    
    # Creates an order fulfillment batch.
    #
    # A sample workflow:
    #
    #   feed = client.new_order_fulfillment_feed
    #   fulfilled_order = new_fulfilled_order :order_id    => "123-1234567-1234567",
    #                                         :order_date  => "2009-08-01"
    #   feed << fulfilled_order
    #   feed.upload
    #   feed.status
    #   => "_SUBMITTED_"
    #
    # Now, refresh the status until you see:
    #
    #   report.status!
    #   => "_DONE_"
    #
    # Finally, check the processing report:
    #
    #   report.download.to_s
    #
    def new_order_fulfillment_feed
      Peddler::Feeds::OrderFulfillment::Batch.new(self.transport.dup)
    end
    
    # Creates an item that can then be added to an order fulfillment feed. Keys are lowercased and underscored but
    # otherwise the same as Amazon's headers. See section 7.1 in the API docs.
    def new_fulfilled_order(params={})
      Peddler::Feeds::OrderFulfillment::Item.new(params)
    end
    
    # Creates an order cancellation batch.
    #
    # A sample workflow:
    #
    #   feed = client.new_order_cancellation_feed
    #   cancelled_order = new_fulfilled_order :order_id    => "123-1234567-1234567"
    #   feed << cancelled_order
    #   feed.upload
    #   feed.status
    #   => "_SUBMITTED_"
    #
    # Now, refresh the status until you see:
    #
    #   report.status!
    #   => "_DONE_"
    #
    # Finally, check the processing report:
    #
    #   report.download.to_s
    #
    def new_order_cancellation_feed
      Peddler::Feeds::OrderCancellation::Batch.new(self.transport.dup)
    end
    
    # Creates an item that can then be added to an order cancellation feed. Keys are lowercased and underscored but
    # otherwise the same as Amazon's headers. See section 7.4 in the API docs.
    def new_cancelled_order(params={})
      Peddler::Feeds::OrderCancellation::Item.new(params)
    end
    
    # Creates a refund batch.
    #
    #   batch = client.new_refund_batch
    #   refund = client.new_refund :order_id                 => "123-1234567-1234567",
    #                              :payments_transaction_id  => "12341234567890",
    #                              :refund_amount            => 10.00,
    #                              :reason                   => "CouldNotShip",
    #                              :message                  => "With our apologies."
    #   batch << refund
    #   batch.upload
    #
    # To follow up on the status of the upload a little while afterwards:
    #
    #   status = client.latest_reports :batch_refund, :count => 1
    #   report = client.new_report :batch_refund, :id => status[0].id
    #   
    # Assuming the refund was successfully processed, report.body should now output:
    #
    #   "123-1234567-1234567order-item-id: 12341234567890\tSUCCESS 10.00 is Refunded.\r\n"
    #
    def new_refund_batch
      Peddler::Refunds::Batch.new(self.transport.dup)
    end
    
    # Creates a refund item that can then be added to a refund batch.
    #
    # Reasons can be [ "GeneralAdjustment" "CouldNotShip" "DifferentItem" "MerchandiseNotReceived" "MerchandiseNotAsDescribed" ].
    def new_refund(params={})
      Peddler::Refunds::Item.new(params)
    end
    
    # Creates an instance for an already-generated report. Works only with what I call legacy reports, that is,
    # anything that comes before section 7 in the API docs.
    # 
    # Report names can be [ :upload, :order, :preorder, :batch_refund, :open_listings, :open_listings_lite, :open_listings_liter ].
    #
    # You can download a specific report by using its ID. Otherwise, the instance will fetch the latest available report. One
    # oddball exception: upload reports do require an ID and will return nil if you don't provide one.
    # 
    #   orders_report = client.new_report :order
    #   orders = Peddler::Handlers::TabDelimitedHandler.decode_response(orders_report.body)
    #   orders[0].buyer_name
    #   => "John Doe"
    #
    #   preorders_report = client.new_report :preorder, :product_line => "Books", :frequency => 2
    #   preorders = Peddler::Handlers::TabDelimitedHandler.decode_response(preorders_report.body)
    #   preorders[0].average_asking_price
    #   => "100"
    # 
    def new_report(name,params={})
      Peddler::LegacyReports::Report.new(self.transport.dup, name, params)
    end
    
    # Requests a report. Returns true when successful. Name works with the following values:
    #
    # [ :order, :open_listings, :open_listings_lite, :open_listings_liter ]
    #
    # Here's some sample usage:
    #
    #   client.generate_report :order, :number_of_days => 15
    #
    #   client.generate_report :open_listings
    #
    # A word of caution. Open listings may crap up with larger inventories. I will have to migrate to a cURL-based
    # HTTP client to get that working again.
    def generate_report(name,params={})
      Peddler::LegacyReports.generate(self.transport, name, params)
    end
    
    # Creates an unshipped order report. Takes on some optional parameters, such as :id, :starts_at, :ends_at. By default,
    # it will request a new unshipped order report for the past seven days.
    #
    #   report = client.new_unshipped_order_report
    #   report.status
    #   => "_SUBMITTED_"
    #
    # Now, refresh the status until you see:
    #
    #   report.status!
    #   => "_DONE_"
    #
    # Once done, you'll get a nifty array of unshipped orders:
    #
    #   report.unshipped_orders
    #   
    def new_unshipped_orders_report(params={})
      Peddler::Reports::UnshippedOrdersReport.new(self.transport.dup, params)
    end
    
    # Returns status of most recent reports. Optional "count" defaults to 10. Name works with the following values:
    #
    # [ :upload, :order, :batch_refund, :open_listings, :open_listings_lite, :open_listings_liter ]
    #
    # Some sample usage:
    #
    #   reports = client.latest_reports :order, :count => 1
    #   reports[0]
    #   => #<Peddler::LegacyReports::ReportStatus starts_at="07-29-2009:10-00-06" ... 
    #
    def latest_reports(name,params={})
      Peddler::LegacyReports.latest(self.transport, name, params)
    end
    
  protected
    def transport #:nodoc:all
      @transport ||= Peddler::Transport.new
    end
  end
end