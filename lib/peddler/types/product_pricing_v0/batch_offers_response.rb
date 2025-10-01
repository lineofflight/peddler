# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/get_offers_response"
require "peddler/types/product_pricing_v0/get_offers_http_status_line"

module Peddler
  module Types
    module ProductPricingV0
      # Common schema that present in `ItemOffersResponse` and `ListingOffersResponse`
      BatchOffersResponse = Structure.new do
        # @return [GetOffersResponse]
        attribute(:body, GetOffersResponse)

        # @return [Hash]
        attribute?(:headers, Hash)

        # @return [GetOffersHttpStatusLine]
        attribute?(:status, GetOffersHttpStatusLine)
      end
    end
  end
end
