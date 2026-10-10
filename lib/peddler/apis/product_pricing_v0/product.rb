# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # An item.
      Product = Structure.new do
        attribute(:identifiers, IdentifierType, null: false, from: "Identifiers")

        attribute?(:attribute_sets, Array, from: "AttributeSets")

        attribute?(:competitive_pricing, CompetitivePricingType, from: "CompetitivePricing")

        attribute?(:offers, [OfferType], from: "Offers")

        attribute?(:relationships, Array, from: "Relationships")

        attribute?(:sales_rankings, [SalesRankType], from: "SalesRankings")
      end
    end
  end
end
