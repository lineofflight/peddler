# frozen_string_literal: true

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
