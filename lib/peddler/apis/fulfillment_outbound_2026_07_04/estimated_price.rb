# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # The estimated price information for the fulfillment order.
      EstimatedPrice = Structure.new do
        # @return [Array<RollupPrice>] A breakdown of the price associated with the delivery preview.
        attribute(:rollup_prices, [RollupPrice], null: false, from: "rollupPrices")

        # @return [Money] The total price associated with the delivery preview.
        attribute(:total_price, Money, null: false, from: "totalPrice")
      end
    end
  end
end
