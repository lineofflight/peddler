# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The item level per unit cost provided by the seller and applicable to Fulfillment by Amazon (FBA) products.
      # Fields in this type will be null if not provided by the seller.
      FBAPerUnitCost = Structure.new do
        # @return [Amount] Cost of shipping the Fulfillment by Amazon (FBA) item to an Amazon fulfillment center. This
        #   value is provided by the seller and applicable to Fulfillment by Amazon (FBA) products.
        attribute?(:shipping_to_amazon_cost, Amount, from: "shippingToAmazonCost")
      end
    end
  end
end
