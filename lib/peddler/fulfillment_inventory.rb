require 'peddler/service'

module Peddler
  # The Fulfillment Inventory API lets you see what is available in your
  # inventory. It's a real-time reporting mechanism that returns your current
  # or recently-changed inventory supply in the Amazon fulfillment network.
  class FulfillmentInventory < Service
    path 'FulfillmentInventory/2010-10-01'
  end
end
