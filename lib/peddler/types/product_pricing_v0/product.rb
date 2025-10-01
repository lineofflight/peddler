# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/identifier_type"
require "peddler/types/product_pricing_v0/competitive_pricing_type"
require "peddler/types/product_pricing_v0/offer_type"
require "peddler/types/product_pricing_v0/sales_rank_type"

module Peddler
  module Types
    module ProductPricingV0
      # An item.
      Product = Structure.new do
        # @return [IdentifierType]
        attribute(:identifiers, IdentifierType, from: "Identifiers")

        # @return [Array<Object>]
        attribute?(:attribute_sets, Array, from: "AttributeSets")

        # @return [CompetitivePricingType]
        attribute?(:competitive_pricing, CompetitivePricingType, from: "CompetitivePricing")

        # @return [Array<OfferType>]
        attribute?(:offers, [OfferType], from: "Offers")

        # @return [Array<Object>]
        attribute?(:relationships, Array, from: "Relationships")

        # @return [Array<SalesRankType>]
        attribute?(:sales_rankings, [SalesRankType], from: "SalesRankings")
      end
    end
  end
end
