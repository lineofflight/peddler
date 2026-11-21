# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Common schema that present in `ItemOffersResponse` and `ListingOffersResponse`
      BatchOffersResponse = Structure.new do
        attribute(:body, GetOffersResponse, null: false)

        attribute?(:headers, HttpResponseHeaders)

        attribute?(:status, GetOffersHttpStatusLine)
      end
    end
  end
end
