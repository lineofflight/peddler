# frozen_string_literal: true

require "peddler/money"

module Peddler
  module Types
    module VendorShipmentsV1
      # Item details for be provided for every item in shipment at either the item or carton or pallet level, whichever
      # is appropriate.
      PurchaseOrderItemDetails = Structure.new do
        # @return [Money] Maximum retail price of the item being shipped.
        attribute(:maximum_retail_price, Money, from: "maximumRetailPrice")
      end
    end
  end
end
