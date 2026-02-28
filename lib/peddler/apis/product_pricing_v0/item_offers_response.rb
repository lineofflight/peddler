# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Schema for an individual `ItemOffersResponse`
      ItemOffersResponse = Structure.new do
        # @return [GetOffersResponse]
        attribute(:body, GetOffersResponse, null: false)

        # @return [ItemOffersRequestParams]
        attribute(:request, ItemOffersRequestParams, null: false)

        # @return [HttpResponseHeaders]
        attribute?(:headers, HttpResponseHeaders)

        # @return [GetOffersHttpStatusLine]
        attribute?(:status, GetOffersHttpStatusLine)
      end
    end
  end
end
