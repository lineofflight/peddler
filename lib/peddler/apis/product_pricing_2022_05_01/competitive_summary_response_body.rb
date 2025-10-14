# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The `competitiveSummaryResponse` body for a requested ASIN and `marketplaceId`.
      CompetitiveSummaryResponseBody = Structure.new do
        # @return [String] The Amazon identifier for the item.
        attribute(:asin, String)

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<Error>] A list of errors
        attribute?(:errors, [Error])

        # @return [Array<FeaturedBuyingOption>] A list of featured buying options for the specified ASIN `marketplaceId`
        # combination.
        attribute?(:featured_buying_options, [FeaturedBuyingOption], from: "featuredBuyingOptions")

        # @return [Array<LowestPricedOffer>] A list of lowest priced offers for the specified ASIN `marketplaceId`
        # combination.
        attribute?(:lowest_priced_offers, [LowestPricedOffer], from: "lowestPricedOffers")

        # @return [Array<ReferencePrice>] A list of reference prices for the specified ASIN `marketplaceId` combination.
        attribute?(:reference_prices, [ReferencePrice], from: "referencePrices")
      end
    end
  end
end
