# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      BuyBoxPrice = Structure.new do
        # @return [String]
        attribute(:condition, String, from: "Condition")

        # @return [Money]
        attribute(:landed_price, Money, from: "LandedPrice")

        # @return [Money]
        attribute(:listing_price, Money, from: "ListingPrice")

        # @return [Points]
        attribute(:points, Points, from: "Points")

        # @return [Money]
        attribute(:shipping, Money, from: "Shipping")
      end
    end
  end
end
