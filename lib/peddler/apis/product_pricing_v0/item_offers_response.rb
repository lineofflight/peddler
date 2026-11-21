# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Schema for an individual `ItemOffersResponse`
      ItemOffersResponse = Structure.new do
        attribute(:body, GetOffersResponse, null: false)

        attribute(:request, ItemOffersRequestParams, null: false)

        attribute?(:headers, HttpResponseHeaders)

        attribute?(:status, GetOffersHttpStatusLine)
      end
    end
  end
end
