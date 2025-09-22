# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_2022_05_01/offer_identifier"
require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_result"
require "peddler/types/product_pricing_2022_05_01/error"

module Peddler
  module Types
    module ProductPricing20220501
      # The FOEP response data for a requested SKU.
      FeaturedOfferExpectedPriceResponseBody = Structure.new do
        # @return [OfferIdentifier] Metadata that identifies the target offer for which the FOEP result data was
        # computed.
        attribute(:offer_identifier, OfferIdentifier, from: "offerIdentifier")

        # @return [Array<FeaturedOfferExpectedPriceResult>] The FOEP results for the requested target offer.
        attribute(:featured_offer_expected_price_results, [FeaturedOfferExpectedPriceResult], from: "featuredOfferExpectedPriceResults")

        # @return [Array<Error>] The errors that occurred if the operation wasn't successful (HTTP status code non-200).
        attribute(:errors, [Error])
      end
    end
  end
end
