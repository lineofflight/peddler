# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      Offer = Structure.new do
        # @return [:boolean] Indicates whether the offer is fulfilled by Amazon
        attribute(:fulfilled_by_amazon, :boolean, null: false, from: "IsFulfilledByAmazon")

        # @return [Money]
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # @return [String] The seller identifier for the offer
        attribute(:seller_id, String, null: false, from: "SellerId")

        # @return [Money]
        attribute(:shipping, Money, null: false, from: "Shipping")

        # @return [Hash]
        attribute(:shipping_time, Hash, null: false, from: "ShippingTime")

        # @return [String] The subcondition of the item
        attribute(:sub_condition, String, null: false, from: "SubCondition")

        # @return [String] Information about the condition of the item
        attribute?(:condition_notes, String, from: "ConditionNotes")

        # @return [:boolean] Indicates whether the offer is currently in the Buy Box. There can be up to two Buy Box
        #   winners at any time per ASIN, one that is eligible for Prime and one that is not eligible for Prime
        attribute?(:buy_box_winner, :boolean, from: "IsBuyBoxWinner")

        # @return [:boolean] Indicates whether the seller of the item is eligible to win the Buy Box
        attribute?(:featured_merchant, :boolean, from: "IsFeaturedMerchant")

        # @return [Points]
        attribute?(:points, Points, from: "Points")

        # @return [PrimeInformation]
        attribute?(:prime_information, PrimeInformation, from: "PrimeInformation")

        # @return [Array<QuantityDiscountPriceType>] Contains a list of pricing information that includes special
        #   pricing when buying in bulk
        attribute?(:quantity_discount_price, [QuantityDiscountPriceType], from: "QuantityDiscountPrice")

        # @return [SellerFeedbackRating]
        attribute?(:seller_feedback_rating, SellerFeedbackRating, from: "SellerFeedbackRating")

        # @return [ShipsFrom]
        attribute?(:ships_from, ShipsFrom, from: "ShipsFrom")
      end
    end
  end
end
