# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Product identifier input that locates a product for MCF.
      ProductIdentifier = Structure.new do
        # @return [String] The merchant SKU for the product.
        attribute(:merchant_sku, String, from: "merchantSku")
      end
    end
  end
end
