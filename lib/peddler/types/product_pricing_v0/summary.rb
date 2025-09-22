# frozen_string_literal: true

require "peddler/types/money"
require "peddler/types/product_pricing_v0/offer_count_type"
require "peddler/types/product_pricing_v0/lowest_price_type"
require "peddler/types/product_pricing_v0/buy_box_price_type"
require "peddler/types/product_pricing_v0/money_type"
require "peddler/types/product_pricing_v0/sales_rank_type"

module Peddler
  module Types
    module ProductPricingV0
      # Contains price information about the product, including the LowestPrices and BuyBoxPrices, the ListPrice, the
      # SuggestedLowerPricePlusShipping, and NumberOfOffers and NumberOfBuyBoxEligibleOffers.
      Summary = Structure.new do
        # @return [Integer] The number of unique offers contained in NumberOfOffers.
        attribute(:total_offer_count, Integer, from: "TotalOfferCount")

        # @return [Array<OfferCountType>] A list that contains the total number of offers for the item for the given
        # conditions and fulfillment channels.
        attribute(:number_of_offers, [OfferCountType], from: "NumberOfOffers")

        # @return [Array<LowestPriceType>] A list of the lowest prices for the item.
        attribute(:lowest_prices, [LowestPriceType], from: "LowestPrices")

        # @return [Array<BuyBoxPriceType>] A list of item prices.
        attribute(:buy_box_prices, [BuyBoxPriceType], from: "BuyBoxPrices")

        # @return [Types::Money] The list price of the item as suggested by the manufacturer.
        attribute(:list_price, Types::Money, from: "ListPrice")

        # @return [Types::Money] This price is based on competitive prices from other retailers (excluding other Amazon
        # sellers). The offer may be ineligible for the Buy Box if the seller's price + shipping (minus Amazon Points)
        # is greater than this competitive price.
        attribute(:competitive_price_threshold, Types::Money, from: "CompetitivePriceThreshold")

        # @return [Types::Money] The suggested lower price of the item, including shipping and Amazon Points. The
        # suggested lower price is based on a range of factors, including historical selling prices, recent Buy
        # Box-eligible prices, and input from customers for your products.
        attribute(:suggested_lower_price_plus_shipping, Types::Money, from: "SuggestedLowerPricePlusShipping")

        # @return [Array<SalesRankType>] A list that contains the sales rank of the item in the given product
        # categories.
        attribute(:sales_rankings, [SalesRankType], from: "SalesRankings")

        # @return [Array<OfferCountType>] A list that contains the total number of offers that are eligible for the Buy
        # Box for the given conditions and fulfillment channels.
        attribute(:buy_box_eligible_offers, [OfferCountType], from: "BuyBoxEligibleOffers")

        # @return [String] When the status is ActiveButTooSoonForProcessing, this is the time when the offers will be
        # available for processing.
        attribute(:offers_available_time, String, from: "OffersAvailableTime")
      end
    end
  end
end
