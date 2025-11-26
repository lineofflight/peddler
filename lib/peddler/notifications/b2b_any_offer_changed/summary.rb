# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      Summary = Structure.new do
        # @return [Array<OfferCount>] A list that contains the total number of B2B offers that are eligible for the Buy
        #   Box for the given conditions and fulfillment channels.
        attribute(:buy_box_eligible_offers, [OfferCount], from: "buyBoxEligibleOffers")

        # @return [Array<LowestPrice>] A list that contains the lowest prices of the item for the given conditions,
        #   fulfillment channels, quantity tiers, and discount types.
        attribute(:lowest_prices, [LowestPrice], from: "lowestPrices")

        # @return [Array<OfferCount>] A list that contains the total number of B2B offers for the item for the given
        #   conditions and fulfillment channels.
        attribute(:number_of_offers, [OfferCount], from: "numberOfOffers")

        # @return [Array<BuyBoxPrice>] A list that contains the Buy Box price of the item for the given conditions,
        #   quantity tiers, and discount types.
        attribute?(:buy_box_prices, [BuyBoxPrice], from: "buyBoxPrices")
      end
    end
  end
end
