# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      BuyBoxPrice = Structure.new do
        # @return [String]
        attribute(:condition, String)

        # @return [Money]
        attribute(:landed_price, Money, from: "landedPrice")

        # @return [Money]
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [Money]
        attribute(:shipping, Money)

        # @return [Points]
        attribute?(:points, Points)
      end
    end
  end
end
