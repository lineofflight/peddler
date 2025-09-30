# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/lowest_priced_offers_input"

module Peddler
  module Types
    module ProductPricing20220501
      # An individual `competitiveSummary` request for an ASIN and `marketplaceId`.
      CompetitiveSummaryRequest = Structure.new do
        # @return [String] The Amazon Standard Identification Number for the item.
        attribute(:asin, String)

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Array<CompetitiveSummaryIncludedData>] The list of requested competitive pricing data for the
        # product.
        attribute(:included_data, Array, from: "includedData")

        # @return [Array<LowestPricedOffersInput>] The list of `lowestPricedOffersInput` parameters that are used to
        # build `lowestPricedOffers` in the response. This attribute is only valid if `lowestPricedOffers` is requested
        # in `includedData`
        attribute?(:lowest_priced_offers_inputs, [LowestPricedOffersInput], from: "lowestPricedOffersInputs")

        # @return [String] HTTP method type
        attribute(:method, String)

        # @return [String] The URI associated with the individual APIs that are called as part of the batch request. For
        # `getCompetitiveSummary`, this is `/products/pricing/2022-05-01/items/competitiveSummary`.
        attribute(:uri, String)
      end
    end
  end
end
