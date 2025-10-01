# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FBAInventoryV1
      # An item to be created in the inventory.
      CreateInventoryItemRequest = Structure.new do
        # @return [String] The marketplaceId.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [String] The name of the item.
        attribute(:product_name, String, from: "productName")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, from: "sellerSku")
      end
    end
  end
end
