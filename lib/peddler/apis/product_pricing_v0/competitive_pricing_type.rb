# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Competitive pricing information for the item.
      CompetitivePricingType = Structure.new do
        # @return [Array<CompetitivePriceType>]
        attribute(:competitive_prices, [CompetitivePriceType], null: false, from: "CompetitivePrices")

        # @return [Array<OfferListingCountType>]
        attribute(:number_of_offer_listings, [OfferListingCountType], null: false, from: "NumberOfOfferListings")

        # @return [Money] The trade-in value of the item in the trade-in program.
        attribute?(:trade_in_value, Money, from: "TradeInValue")
      end
    end
  end
end
