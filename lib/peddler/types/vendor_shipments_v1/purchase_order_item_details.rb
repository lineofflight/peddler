# frozen_string_literal: true

require "peddler/types/money"

module Peddler
  module Types
    module VendorShipmentsV1
      # Item details for be provided for every item in shipment at either the item or carton or pallet level, whichever
      # is appropriate.
      PurchaseOrderItemDetails = Structure.new do
        # @return [Types::Money] Maximum retail price of the item being shipped.
        attribute(:maximum_retail_price, Types::Money, from: "maximumRetailPrice")
      end
    end
  end
end
