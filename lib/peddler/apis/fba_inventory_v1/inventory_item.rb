# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # An item in the list of inventory to be added.
      InventoryItem = Structure.new do
        # @return [String] The marketplaceId.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Integer] The quantity of item to add.
        attribute(:quantity, Integer, null: false)

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, null: false, from: "sellerSku")
      end
    end
  end
end
