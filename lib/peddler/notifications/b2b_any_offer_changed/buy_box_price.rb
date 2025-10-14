# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      BuyBoxPrice = Structure.new do
        # @return [String]
        attribute(:condition, String)

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

        # @return [String] The seller identifier for the offer.
        attribute?(:seller_id, String, from: "sellerId")

        # @return [Money]
        attribute?(:shipping, Money)
      end
    end
  end
end
