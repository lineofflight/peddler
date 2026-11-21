# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # Offer details of the merchant receiving the notification
      MerchantOffer = Structure.new do
        attribute(:condition, String, null: false)

        attribute(:fulfillment_type, String, null: false, from: "fulfillmentType")

        attribute(:landed_price, Money, null: false, from: "landedPrice")

        attribute(:listing_price, Money, null: false, from: "listingPrice")

        attribute(:shipping, Money, null: false)

        attribute?(:points, Points)
      end
    end
  end
end
