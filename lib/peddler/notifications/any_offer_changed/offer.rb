# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module AnyOfferChanged
      Offer = Structure.new do
        # @return [:boolean]
        attribute(:fulfilled_by_amazon, :boolean, null: false, from: "IsFulfilledByAmazon")

        # @return [Money]
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # @return [String]
        attribute(:seller_id, String, null: false, from: "SellerId")

        # @return [Money]
        attribute(:shipping, Money, null: false, from: "Shipping")

        # @return [ShippingTime]
        attribute(:shipping_time, ShippingTime, null: false, from: "ShippingTime")

        # @return [String]
        attribute(:sub_condition, String, null: false, from: "SubCondition")

        # @return [:boolean] True when the offer is currently in the Buy Box. There can be up to two Buy Box winners at
        #   any time per ASIN, one that is eligible for Prime and one that is not eligible for Prime.
        attribute?(:buy_box_winner, :boolean, from: "IsBuyBoxWinner")

        # @return [:boolean]
        attribute?(:expedited_shipping_available, :boolean, from: "IsExpeditedShippingAvailable")

        # @return [:boolean]
        attribute?(:featured_merchant, :boolean, from: "IsFeaturedMerchant")

        # @return [Points]
        attribute?(:points, Points, from: "Points")

        # @return [PrimeInformation]
        attribute?(:prime_information, PrimeInformation, from: "PrimeInformation")

        # @return [SellerFeedbackRating]
        attribute?(:seller_feedback_rating, SellerFeedbackRating, from: "SellerFeedbackRating")

        # @return [:boolean]
        attribute?(:ships_domestically, :boolean, from: "ShipsDomestically")

        # @return [ShipsFrom]
        attribute?(:ships_from, ShipsFrom, from: "ShipsFrom")

        # @return [:boolean]
        attribute?(:ships_internationally, :boolean, from: "ShipsInternationally")
      end
    end
  end
end
