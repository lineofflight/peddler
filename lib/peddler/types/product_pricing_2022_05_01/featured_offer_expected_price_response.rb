# frozen_string_literal: true

require "peddler/types/product_pricing_2022_05_01/http_headers"
require "peddler/types/product_pricing_2022_05_01/http_status_line"
require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_request_params"
require "peddler/types/product_pricing_2022_05_01/featured_offer_expected_price_response_body"

module Peddler
  module Types
    module ProductPricing20220501
      # Schema for an individual FOEP response.
      FeaturedOfferExpectedPriceResponse = Structure.new do
        # @return [HttpHeaders]
        attribute(:headers, HttpHeaders)

        # @return [HttpStatusLine]
        attribute(:status, HttpStatusLine)

        # @return [FeaturedOfferExpectedPriceRequestParams] Use these request parameters to map the response back to the
        # request.
        attribute(:request, FeaturedOfferExpectedPriceRequestParams)

        # @return [FeaturedOfferExpectedPriceResponseBody]
        attribute(:body, FeaturedOfferExpectedPriceResponseBody)
      end
    end
  end
end
