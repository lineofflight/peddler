# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # Offer details of the merchant receiving the notification
      MerchantOffer = Structure.new do
        # @return [String]
        attribute(:condition, String)

        # @return [String]
        attribute(:fulfillment_type, String, from: "fulfillmentType")

        # @return [Money]
        attribute(:landed_price, Money, from: "landedPrice")

        # @return [Money]
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [Money]
        attribute(:shipping, Money)

        # @return [String]
        attribute?(:points, String)
      end
    end
  end
end
