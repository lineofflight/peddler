# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      Summary = Structure.new do
        # @return [Array]
        attribute(:buy_box_prices, Array, from: "BuyBoxPrices")

        # @return [Money]
        attribute(:competitive_price_threshold, Money, from: "CompetitivePriceThreshold")

        # @return [Money]
        attribute(:list_price, Money, from: "ListPrice")

        # @return [Array]
        attribute(:lowest_prices, Array, from: "LowestPrices")

        # @return [Money]
        attribute(:minimum_advertised_price, Money, from: "MinimumAdvertisedPrice")

        # @return [Array]
        attribute(:number_of_buy_box_eligible_offers, Array, from: "NumberOfBuyBoxEligibleOffers")

        # @return [Array]
        attribute(:number_of_offers, Array, from: "NumberOfOffers")

        # @return [Array]
        attribute(:sales_rankings, Array, from: "SalesRankings")

        # @return [Money]
        attribute(:suggested_lower_price_plus_shipping, Money, from: "SuggestedLowerPricePlusShipping")

        # @return [Integer]
        attribute(:total_buy_box_eligible_offers, Integer, from: "TotalBuyBoxEligibleOffers")
      end
    end
  end
end
