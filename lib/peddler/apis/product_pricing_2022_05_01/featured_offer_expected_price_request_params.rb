# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The parameters for an individual request.
      FeaturedOfferExpectedPriceRequestParams = Structure.new do
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        attribute(:sku, String, null: false)

        attribute?(:segment, Segment)
      end
    end
  end
end
