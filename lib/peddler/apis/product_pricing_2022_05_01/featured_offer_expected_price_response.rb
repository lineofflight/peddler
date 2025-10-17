# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Schema for an individual FOEP response.
      FeaturedOfferExpectedPriceResponse = Structure.new do
        # @return [Hash]
        attribute(:headers, Hash)

        # @return [FeaturedOfferExpectedPriceRequestParams] Use these request parameters to map the response back to the
        #   request.
        attribute(:request, FeaturedOfferExpectedPriceRequestParams)

        # @return [HttpStatusLine]
        attribute(:status, HttpStatusLine)

        # @return [FeaturedOfferExpectedPriceResponseBody]
        attribute?(:body, FeaturedOfferExpectedPriceResponseBody)
      end
    end
  end
end
