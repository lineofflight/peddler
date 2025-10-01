# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/get_offers_response"
require "peddler/types/product_pricing_v0/item_offers_request_params"
require "peddler/types/product_pricing_v0/get_offers_http_status_line"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for an individual `ItemOffersResponse`
      ItemOffersResponse = Structure.new do
        # @return [GetOffersResponse]
        attribute(:body, GetOffersResponse)

        # @return [ItemOffersRequestParams]
        attribute(:request, ItemOffersRequestParams)

        # @return [Hash]
        attribute?(:headers, Hash)

        # @return [GetOffersHttpStatusLine]
        attribute?(:status, GetOffersHttpStatusLine)
      end
    end
  end
end
