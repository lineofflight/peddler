# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/featured_buying_option"
require "peddler/types/product_pricing_2022_05_01/lowest_priced_offer"
require "peddler/types/product_pricing_2022_05_01/reference_price"
require "peddler/types/product_pricing_2022_05_01/error"

module Peddler
  module Types
    module ProductPricing20220501
      # The `competitiveSummaryResponse` body for a requested ASIN and `marketplaceId`.
      CompetitiveSummaryResponseBody = Structure.new do
        # @return [String] The Amazon identifier for the item.
        attribute(:asin, String)

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<FeaturedBuyingOption>] A list of featured buying options for the specified ASIN `marketplaceId`
        # combination.
        attribute?(:featured_buying_options, [FeaturedBuyingOption], from: "featuredBuyingOptions")

        # @return [Array<LowestPricedOffer>] A list of lowest priced offers for the specified ASIN `marketplaceId`
        # combination.
        attribute?(:lowest_priced_offers, [LowestPricedOffer], from: "lowestPricedOffers")

        # @return [Array<ReferencePrice>] A list of reference prices for the specified ASIN `marketplaceId` combination.
        attribute?(:reference_prices, [ReferencePrice], from: "referencePrices")

        # @return [Array<Error>] A list of errors
        attribute?(:errors, [Error])
      end
    end
  end
end
