# frozen_string_literal: true

require "peddler/money"
require "peddler/types/product_pricing_v0/competitive_price_type"
require "peddler/types/product_pricing_v0/offer_listing_count_type"
require "peddler/types/product_pricing_v0/money_type"

module Peddler
  module Types
    module ProductPricingV0
      # Competitive pricing information for the item.
      CompetitivePricingType = Structure.new do
        # @return [Array<CompetitivePriceType>]
        attribute(:competitive_prices, [CompetitivePriceType], from: "CompetitivePrices")

        # @return [Array<OfferListingCountType>]
        attribute(:number_of_offer_listings, [OfferListingCountType], from: "NumberOfOfferListings")

        # @return [Money] The trade-in value of the item in the trade-in program.
        attribute(:trade_in_value, Money, from: "TradeInValue")
      end
    end
  end
end
