# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FBAInventoryV1
      # An item to be created in the inventory.
      CreateInventoryItemRequest = Structure.new do
        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")

        # @return [String] The marketplaceId.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The name of the item.
        attribute(:product_name, String, from: "productName")
      end
    end
  end
end
