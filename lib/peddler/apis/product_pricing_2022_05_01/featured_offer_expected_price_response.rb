# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # Schema for an individual FOEP response.
      FeaturedOfferExpectedPriceResponse = Structure.new do
        attribute(:headers, Hash, null: false)

        # Use these request parameters to map the response back to the request.
        attribute(:request, FeaturedOfferExpectedPriceRequestParams, null: false)

        attribute(:status, HttpStatusLine, null: false)

        attribute?(:body, FeaturedOfferExpectedPriceResponseBody)
      end
    end
  end
end
