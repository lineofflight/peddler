# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      BuyBoxPrice = Structure.new do
        attribute(:condition, String, null: false, from: "Condition")

        attribute(:landed_price, Money, null: false, from: "LandedPrice")

        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        attribute(:points, Points, null: false, from: "Points")

        attribute(:shipping, Money, null: false, from: "Shipping")
      end
    end
  end
end
