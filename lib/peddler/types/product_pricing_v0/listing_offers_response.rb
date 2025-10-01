# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/get_offers_response"
require "peddler/types/product_pricing_v0/http_response_headers"
require "peddler/types/product_pricing_v0/listing_offers_request_params"
require "peddler/types/product_pricing_v0/get_offers_http_status_line"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for an individual `ListingOffersResponse`
      ListingOffersResponse = Structure.new do
        # @return [GetOffersResponse]
        attribute(:body, GetOffersResponse)

        # @return [HttpResponseHeaders]
        attribute?(:headers, HttpResponseHeaders)

        # @return [ListingOffersRequestParams]
        attribute?(:request, ListingOffersRequestParams)

        # @return [GetOffersHttpStatusLine]
        attribute?(:status, GetOffersHttpStatusLine)
      end
    end
  end
end
