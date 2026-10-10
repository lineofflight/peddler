# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      Summary = Structure.new do
        attribute(:lowest_prices, Array, null: false, from: "LowestPrices")

        attribute(:number_of_buy_box_eligible_offers, Array, null: false, from: "NumberOfBuyBoxEligibleOffers")

        attribute(:number_of_offers, Array, null: false, from: "NumberOfOffers")

        attribute?(:buy_box_prices, Array, from: "BuyBoxPrices")

        attribute?(:competitive_price_threshold, Money, from: "CompetitivePriceThreshold")

        attribute?(:list_price, Money, from: "ListPrice")

        attribute?(:minimum_advertised_price, Money, from: "MinimumAdvertisedPrice")

        attribute?(:sales_rankings, Array, from: "SalesRankings")

        attribute?(:suggested_lower_price_plus_shipping, Money, from: "SuggestedLowerPricePlusShipping")

        attribute?(:total_buy_box_eligible_offers, Integer, from: "TotalBuyBoxEligibleOffers")
      end
    end
  end
end
