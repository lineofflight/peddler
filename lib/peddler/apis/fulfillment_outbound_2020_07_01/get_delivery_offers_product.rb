# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The product details for the delivery offer.
      GetDeliveryOffersProduct = Structure.new do
        # @return [ProductIdentifier] Product identifier input that locates a product for MCF.
        attribute(:product_identifier, ProductIdentifier, null: false, from: "productIdentifier")

        # @return [Amount] The amount of the requested product.
        attribute?(:amount, Amount)
      end
    end
  end
end
