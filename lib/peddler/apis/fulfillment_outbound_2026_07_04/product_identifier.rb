# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The identifier of a product.
      ProductIdentifier = Structure.new do
        # @return [String] The Amazon SKU of the item.
        attribute(:amazon_sku, String, null: false, from: "amazonSku")
      end
    end
  end
end
