# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      LowestPrice = Structure.new do
        # @return [String]
        attribute(:condition, String)

        # @return [String]
        attribute(:fulfillment_channel, String, from: "fulfillmentChannel")

        # @return [Money]
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [String]
        attribute(:offer_type, String, from: "offerType")

        # @return [String]
        attribute(:quantity_tier, String, from: "quantityTier")

        # @return [String]
        attribute?(:discount_type, String, from: "discountType")

        # @return [Money]
        attribute?(:landed_price, Money, from: "landedPrice")

        # @return [Money]
        attribute?(:shipping, Money)
      end
    end
  end
end
