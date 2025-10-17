# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The FOEP response data for a requested SKU.
      FeaturedOfferExpectedPriceResponseBody = Structure.new do
        # @return [Array<Error>] The errors that occurred if the operation wasn't successful (HTTP status code non-200).
        attribute?(:errors, [Error])

        # @return [Array<FeaturedOfferExpectedPriceResult>] The FOEP results for the requested target offer.
        attribute?(:featured_offer_expected_price_results, [FeaturedOfferExpectedPriceResult], from: "featuredOfferExpectedPriceResults")

        # @return [OfferIdentifier] Metadata that identifies the target offer for which the FOEP result data was
        #   computed.
        attribute?(:offer_identifier, OfferIdentifier, from: "offerIdentifier")
      end
    end
  end
end
