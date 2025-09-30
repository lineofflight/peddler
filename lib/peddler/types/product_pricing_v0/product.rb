# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/identifier_type"
require "peddler/types/product_pricing_v0/competitive_pricing_type"
require "peddler/types/product_pricing_v0/sales_rank_type"
require "peddler/types/product_pricing_v0/offer_type"

module Peddler
  module Types
    module ProductPricingV0
      # An item.
      Product = Structure.new do
        # @return [IdentifierType]
        attribute(:identifiers, IdentifierType, from: "Identifiers")

        # @return [Array<Object>]
        attribute?(:attribute_sets, Array, from: "AttributeSets")

        # @return [Array<Object>]
        attribute?(:relationships, Array, from: "Relationships")

        # @return [CompetitivePricingType]
        attribute?(:competitive_pricing, CompetitivePricingType, from: "CompetitivePricing")

        # @return [Array<SalesRankType>]
        attribute?(:sales_rankings, [SalesRankType], from: "SalesRankings")

        # @return [Array<OfferType>]
        attribute?(:offers, [OfferType], from: "Offers")
      end
    end
  end
end
