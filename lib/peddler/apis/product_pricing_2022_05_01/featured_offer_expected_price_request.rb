# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # An individual FOEP request for a particular SKU.
      FeaturedOfferExpectedPriceRequest = Structure.new do
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        attribute(:method, String, null: false)

        attribute(:sku, String, null: false)

        # The URI associated with an individual request within a batch. For `FeaturedOfferExpectedPrice`, this is
        # `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String, null: false)

        attribute?(:body, Hash)

        attribute?(:headers, Hash)

        attribute?(:segment, Segment)
      end
    end
  end
end
