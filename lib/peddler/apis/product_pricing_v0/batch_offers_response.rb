# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # Common schema that present in `ItemOffersResponse` and `ListingOffersResponse`
      BatchOffersResponse = Structure.new do
        # @return [GetOffersResponse]
        attribute(:body, GetOffersResponse)

        # @return [HttpResponseHeaders]
        attribute?(:headers, HttpResponseHeaders)

        # @return [GetOffersHttpStatusLine]
        attribute?(:status, GetOffersHttpStatusLine)
      end
    end
  end
end
