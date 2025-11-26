# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

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

        # @return [ShippingTime]
        attribute(:shipping_time, ShippingTime, from: "shippingTime")

        # @return [String] The subcondition of the item.
        attribute(:sub_condition, String, from: "subCondition")

        # @return [String] Information about the condition of the item.
        attribute?(:condition_notes, String, from: "conditionNotes")

        # @return [:boolean] True when the offer is currently in the Buy Box. There can be up to two Buy Box winners at
        #   any time per ASIN, one that is eligible for Prime and one that is not eligible for Prime.
        attribute?(:buy_box_winner, :boolean, from: "isBuyBoxWinner")

        # @return [:boolean] True when the seller of the item is eligible to win the Buy Box.
        attribute?(:featured_merchant, :boolean, from: "isFeaturedMerchant")

        # @return [PrimeInformation]
        attribute?(:prime_information, PrimeInformation, from: "primeInformation")

        # @return [Array<QuantityDiscountPriceType>] Contains a list of pricing information that includes special
        #   pricing when buying in bulk.
        attribute?(:quantity_discount_price, [QuantityDiscountPriceType], from: "quantityDiscountPrice")

        # @return [SellerFeedbackRating]
        attribute?(:seller_feedback_rating, SellerFeedbackRating, from: "sellerFeedbackRating")

        # @return [ShipsFrom]
        attribute?(:ships_from, ShipsFrom, from: "shipsFrom")
      end
    end
  end
end
