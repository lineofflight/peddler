# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # An item.
      Product = Structure.new do
        # @return [IdentifierType]
        attribute(:identifiers, IdentifierType, null: false, from: "Identifiers")

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
