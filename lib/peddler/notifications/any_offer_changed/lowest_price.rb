# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module AnyOfferChanged
      LowestPrice = Structure.new do
        # @return [String]
        attribute(:condition, String, null: false, from: "Condition")

        # @return [String]
        attribute(:fulfillment_channel, String, null: false, from: "FulfillmentChannel")

        # @return [Money]
        attribute(:landed_price, Money, null: false, from: "LandedPrice")

        # @return [Money]
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # @return [Points]
        attribute(:points, Points, null: false, from: "Points")

        # @return [Money]
        attribute(:shipping, Money, null: false, from: "Shipping")
      end
    end
  end
end
