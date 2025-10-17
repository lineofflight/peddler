# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      Summary = Structure.new do
        # @return [Array<OfferCount>] A list that contains the total number of offers that are eligible for the Buy Box
        #   for the given conditions and fulfillment channels
        attribute(:buy_box_eligible_offers, [OfferCount], from: "buyBoxEligibleOffers")

        # @return [Array<OfferCount>] A list that contains the total number of offers for the item for the given
        #   conditions and fulfillment channels
        attribute(:number_of_offers, [OfferCount], from: "numberOfOffers")

        # @return [String]
        attribute(:reference_price, String, from: "referencePrice")

        # @return [Array<BuyBoxPrice>] A list that contains the Buy Box price of the item for the given conditions
        attribute?(:buy_box_prices, [BuyBoxPrice], from: "buyBoxPrices")

        # @return [Array<SalesRank>] A list that contains the sales rankings of the asin in various product categories
        attribute?(:sales_rankings, [SalesRank], from: "salesRankings")
      end
    end
  end
end
