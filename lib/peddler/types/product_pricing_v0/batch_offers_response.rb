# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/http_response_headers"
require "peddler/types/product_pricing_v0/get_offers_http_status_line"
require "peddler/types/product_pricing_v0/get_offers_response"

module Peddler
  module Types
    module ProductPricingV0
      # Common schema that present in `ItemOffersResponse` and `ListingOffersResponse`
      BatchOffersResponse = Structure.new do
        # @return [HttpResponseHeaders]
        attribute?(:headers, HttpResponseHeaders)

        # @return [GetOffersHttpStatusLine]
        attribute?(:status, GetOffersHttpStatusLine)

        # @return [GetOffersResponse]
        attribute(:body, GetOffersResponse)
      end
    end
  end
end
