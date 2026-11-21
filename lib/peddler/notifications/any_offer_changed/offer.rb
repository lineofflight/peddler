# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module AnyOfferChanged
      Offer = Structure.new do
        attribute(:fulfilled_by_amazon, :boolean, null: false, from: "IsFulfilledByAmazon")

        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        attribute(:seller_id, String, null: false, from: "SellerId")

        attribute(:shipping, Money, null: false, from: "Shipping")

        attribute(:shipping_time, ShippingTime, null: false, from: "ShippingTime")

        attribute(:sub_condition, String, null: false, from: "SubCondition")

        # True when the offer is currently in the Buy Box. There can be up to two Buy Box winners at any time per ASIN,
        # one that is eligible for Prime and one that is not eligible for Prime.
        attribute?(:buy_box_winner, :boolean, from: "IsBuyBoxWinner")

        attribute?(:expedited_shipping_available, :boolean, from: "IsExpeditedShippingAvailable")

        attribute?(:featured_merchant, :boolean, from: "IsFeaturedMerchant")

        attribute?(:points, Points, from: "Points")

        attribute?(:prime_information, PrimeInformation, from: "PrimeInformation")

        attribute?(:seller_feedback_rating, SellerFeedbackRating, from: "SellerFeedbackRating")

        attribute?(:ships_domestically, :boolean, from: "ShipsDomestically")

        attribute?(:ships_from, ShipsFrom, from: "ShipsFrom")

        attribute?(:ships_internationally, :boolean, from: "ShipsInternationally")
      end
    end
  end
end
