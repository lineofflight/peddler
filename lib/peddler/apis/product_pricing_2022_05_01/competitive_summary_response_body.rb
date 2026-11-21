# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The `competitiveSummaryResponse` body for a requested ASIN and `marketplaceId`.
      CompetitiveSummaryResponseBody = Structure.new do
        # The Amazon identifier for the item.
        attribute(:asin, String, null: false)

        # An Amazon store identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # A list of errors
        attribute?(:errors, [Error])

        # A list of featured buying options for the specified ASIN `marketplaceId` combination.
        attribute?(:featured_buying_options, [FeaturedBuyingOption], from: "featuredBuyingOptions")

        # A list of lowest priced offers for the specified ASIN `marketplaceId` combination.
        attribute?(:lowest_priced_offers, [LowestPricedOffer], from: "lowestPricedOffers")

        # A list of reference prices for the specified ASIN `marketplaceId` combination.
        attribute?(:reference_prices, [ReferencePrice], from: "referencePrices")

        # A list of similar items for the specified ASIN `marketplaceId` combination.
        attribute?(:similar_items, [SimilarItems], from: "similarItems")
      end
    end
  end
end
