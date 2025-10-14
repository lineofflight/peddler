# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # An item in the list of inventory to be added.
      InventoryItem = Structure.new do
        # @return [String] The marketplaceId.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Integer] The quantity of item to add.
        attribute(:quantity, Integer)

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")
      end
    end
  end
end
