# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      BuyBoxPrice = Structure.new do
        # @return [String]
        attribute(:condition, String, null: false)

        # @return [Money]
        attribute(:landed_price, Money, null: false, from: "landedPrice")

        # @return [Money]
        attribute(:listing_price, Money, null: false, from: "listingPrice")

        # @return [Money]
        attribute(:shipping, Money, null: false)

        # @return [Points]
        attribute?(:points, Points)
      end
    end
  end
end
