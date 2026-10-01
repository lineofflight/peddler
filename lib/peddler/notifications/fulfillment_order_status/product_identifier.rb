# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      # Identifies a product.
      ProductIdentifier = Structure.new do
        # @return [String] The merchant SKU of the item.
        attribute(:amazon_sku, String, null: false, from: "amazonSku")
      end
    end
  end
end
