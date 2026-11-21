# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricing20220501
      # The common properties for individual requests within a batch.
      BatchRequest = Structure.new do
        # Known values: `GET`, `PUT`, `PATCH`, `DELETE`, `POST`.
        attribute(:method, String, null: false)

        # The URI associated with an individual request within a batch. For `FeaturedOfferExpectedPrice`, this is
        # `/products/pricing/2022-05-01/offer/featuredOfferExpectedPrice`.
        attribute(:uri, String, null: false)

        attribute?(:body, Hash)

        attribute?(:headers, Hash)
      end
    end
  end
end
