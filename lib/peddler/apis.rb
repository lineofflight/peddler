require 'peddler/service'

module Peddler
  # The Feeds API lets you upload inventory and order data to Amazon.
  class Feeds < Service
  end

  # With the Fulfillment Inbound Shipment API, you can create and update
  # inbound shipments of inventory in the Amazon Fulfillment Network. You can
  #  also request lists of inbound shipments or inbound shipment items based on
  # criteria that you specify.
  class FulfillmentInboundShipment < Service
    path 'FulfillmentInboundShipment/2010-10-01'
  end

  # The Fulfillment Inventory API lets you see what is available in your
  # inventory. It's a real-time reporting mechanism that returns your current
  # or recently-changed inventory supply in the Amazon fulfillment network.
  class FulfillmentInventory < Service
    path 'FulfillmentInventory/2010-10-01'
  end

  # The Fulfillment Outbound Shipment API is designed to help you integrate
  # Fulfillment by Amazon with any payment processing application or inventory
  # management system currently in use.
  class FulfillmentOutboundShipment < Service
    path 'FulfillmentOutboundShipment/2010-10-01'
  end

  # The Orders API helps you build simple applications that retrieve only the
  # order information that you need.
  class Orders < Service
    path 'Orders/2011-01-01'
  end

  # The Products API helps you get information to match your products to
  # existing product listings on Amazon Marketplace websites and to make
  # sourcing and pricing decisions for listing those products on Amazon
  # Marketplace websites.
  class Products < Service
    path 'Products/2011-10-01'
    params('MarketplaceId' => -> { marketplace_id })
  end

  # The Reports API lets you request reports about your inventory and orders.
  class Reports < Service
  end

  # The Sellers API lets sellers retrieve information about their seller
  # account, such as the marketplaces they participate in.
  class Sellers < Service
    path 'Sellers/2011-07-01'
  end
end
