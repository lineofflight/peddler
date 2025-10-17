# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # Schema for `currentFeaturedOffer` or `competingFeaturedOffer`.
      FeaturedOffer = Structure.new do
        # @return [OfferIdentifier] An offer identifier used to identify the merchant of the featured offer. Since this
        #   may not belong to the requester, the SKU field is omitted.
        attribute(:offer_identifier, OfferIdentifier, from: "offerIdentifier")

        # @return [String] The item condition.
        attribute?(:condition, String)

        # @return [Price] The current active price of the offer.
        attribute?(:price, Price)
      end
    end
  end
end
