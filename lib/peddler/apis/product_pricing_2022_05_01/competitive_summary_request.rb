# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # An individual `competitiveSummary` request for an ASIN and `marketplaceId`.
      CompetitiveSummaryRequest = Structure.new do
        # @return [String] The Amazon Standard Identification Number for the item.
        attribute(:asin, String, null: false)

        # @return [Array<CompetitiveSummaryIncludedData>] The list of requested competitive pricing data for the
        #   product.
        attribute(:included_data, Array, null: false, from: "includedData")

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [String] HTTP method type
        attribute(:method, String, null: false)

        # @return [String] The URI associated with the individual APIs that are called as part of the batch request. For
        #   `getCompetitiveSummary`, this is `/products/pricing/2022-05-01/items/competitiveSummary`.
        attribute(:uri, String, null: false)

        # @return [Array<LowestPricedOffersInput>] The list of `lowestPricedOffersInput` parameters that are used to
        #   build `lowestPricedOffers` in the response. This attribute is only valid if `lowestPricedOffers` is
        #   requested in `includedData`
        attribute?(:lowest_priced_offers_inputs, [LowestPricedOffersInput], from: "lowestPricedOffersInputs")
      end
    end
  end
end
