# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FBAInventoryV1
      # An item to be created in the inventory.
      CreateInventoryItemRequest = Structure.new do
        # @return [String] The marketplaceId.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] The name of the item.
        attribute(:product_name, String, null: false, from: "productName")

        # @return [String] The seller SKU of the item.
        attribute(:seller_sku, String, null: false, from: "sellerSku")
      end
    end
  end
end
