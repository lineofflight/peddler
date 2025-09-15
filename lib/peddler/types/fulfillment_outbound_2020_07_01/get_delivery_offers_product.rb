# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/product_identifier"
require "peddler/types/fulfillment_outbound_2020_07_01/amount"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The product details for the delivery offer.
      GetDeliveryOffersProduct = Structure.new do
        # @return [ProductIdentifier] Product identifier input that locates a product for MCF.
        attribute(:product_identifier, ProductIdentifier, from: "productIdentifier")

        # @return [Amount] The amount of the requested product.
        attribute(:amount, Amount)
      end
    end
  end
end
