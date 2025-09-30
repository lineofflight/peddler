# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/http_response_headers"
require "peddler/types/product_pricing_v0/get_offers_http_status_line"
require "peddler/types/product_pricing_v0/get_offers_response"
require "peddler/types/product_pricing_v0/listing_offers_request_params"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for an individual `ListingOffersResponse`
      ListingOffersResponse = Structure.new do
        # @return [HttpResponseHeaders]
        attribute?(:headers, HttpResponseHeaders)

        # @return [GetOffersHttpStatusLine]
        attribute?(:status, GetOffersHttpStatusLine)

        # @return [GetOffersResponse]
        attribute(:body, GetOffersResponse)

        # @return [ListingOffersRequestParams]
        attribute?(:request, ListingOffersRequestParams)
      end
    end
  end
end
