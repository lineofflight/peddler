# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module AnyOfferChanged
      Offer = Structure.new do
        # @return [:boolean]
        attribute(:expedited_shipping_available, :boolean, from: "IsExpeditedShippingAvailable")

        # @return [:boolean]
        attribute(:featured_merchant, :boolean, from: "IsFeaturedMerchant")

        # @return [:boolean]
        attribute(:fulfilled_by_amazon, :boolean, from: "IsFulfilledByAmazon")

        # @return [Money]
        attribute(:listing_price, Money, from: "ListingPrice")

        # @return [Points]
        attribute(:points, Points, from: "Points")

        # @return [PrimeInformation]
        attribute(:prime_information, PrimeInformation, from: "PrimeInformation")

        # @return [SellerFeedbackRating]
        attribute(:seller_feedback_rating, SellerFeedbackRating, from: "SellerFeedbackRating")

        # @return [String]
        attribute(:seller_id, String, from: "SellerId")

        # @return [Money]
        attribute(:shipping, Money, from: "Shipping")

        # @return [ShippingTime]
        attribute(:shipping_time, ShippingTime, from: "ShippingTime")

        # @return [:boolean]
        attribute(:ships_domestically, :boolean, from: "ShipsDomestically")

        # @return [ShipsFrom]
        attribute(:ships_from, ShipsFrom, from: "ShipsFrom")

        # @return [:boolean]
        attribute(:ships_internationally, :boolean, from: "ShipsInternationally")

        # @return [String]
        attribute(:sub_condition, String, from: "SubCondition")
      end
    end
  end
end
