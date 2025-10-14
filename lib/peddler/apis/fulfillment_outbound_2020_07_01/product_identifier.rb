# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # Product identifier input that locates a product for MCF.
      ProductIdentifier = Structure.new do
        # @return [String] The merchant SKU for the product.
        attribute(:merchant_sku, String, from: "merchantSku")
      end
    end
  end
end
