# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module B2BAnyOfferChanged
      Offer = Structure.new do
        # @return [:boolean] True when fulfilled by Amazon.
        attribute(:fulfilled_by_amazon, :boolean, from: "isFulfilledByAmazon")

        # @return [Money]
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [String] The seller identifier for the offer.
        attribute(:seller_id, String, from: "sellerId")

        # @return [Money]
        attribute(:shipping, Money)

        # @return [String]
        attribute(:shipping_time, String, from: "shippingTime")

        # @return [String] The subcondition of the item.
        attribute(:sub_condition, String, from: "subCondition")

        # @return [String] Information about the condition of the item.
        attribute?(:condition_notes, String, from: "conditionNotes")

        # @return [:boolean] True when the offer is currently in the Buy Box. There can be up to two Buy Box winners at
        #   any time per ASIN, one that is eligible for Prime and one that is not eligible for Prime.
        attribute?(:buy_box_winner, :boolean, from: "isBuyBoxWinner")

        # @return [:boolean] True when the seller of the item is eligible to win the Buy Box.
        attribute?(:featured_merchant, :boolean, from: "isFeaturedMerchant")

        # @return [Array<QuantityDiscountPriceType>] Contains a list of pricing information that includes special
        #   pricing when buying in bulk.
        attribute?(:quantity_discount_price, [QuantityDiscountPriceType], from: "quantityDiscountPrice")

        # @return [String]
        attribute?(:seller_feedback_rating, String, from: "sellerFeedbackRating")

        # @return [String]
        attribute?(:ships_from, String, from: "shipsFrom")
      end
    end
  end
end
