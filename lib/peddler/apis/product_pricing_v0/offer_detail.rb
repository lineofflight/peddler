# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ProductPricingV0
      # Schema for an individual offer. Object in `OfferDetailList`.
      OfferDetail = Structure.new do
        # @return [:boolean] When true, the offer is fulfilled by Amazon.
        attribute(:fulfilled_by_amazon, :boolean, null: false, from: "IsFulfilledByAmazon")

        # @return [Money] The price of the item.
        attribute(:listing_price, Money, null: false, from: "ListingPrice")

        # @return [Money] The shipping cost.
        attribute(:shipping, Money, null: false, from: "Shipping")

        # @return [DetailedShippingTimeType] The maximum time within which the item will likely be shipped once an order
        #   has been placed.
        attribute(:shipping_time, DetailedShippingTimeType, null: false, from: "ShippingTime")

        # @return [String] The subcondition of the item. Subcondition values: New, Mint, Very Good, Good, Acceptable,
        #   Poor, Club, OEM, Warranty, Refurbished Warranty, Refurbished, Open Box, or Other.
        attribute(:sub_condition, String, null: false, from: "SubCondition")

        # @return [String] Information about the condition of the item.
        attribute?(:condition_notes, String, from: "ConditionNotes")

        # @return [:boolean] When true, the offer is currently in the Buy Box. There can be up to two Buy Box winners at
        #   any time per ASIN, one that is eligible for Prime and one that is not eligible for Prime.
        attribute?(:buy_box_winner, :boolean, from: "IsBuyBoxWinner")

        # @return [:boolean] When true, the seller of the item is eligible to win the Buy Box.
        attribute?(:featured_merchant, :boolean, from: "IsFeaturedMerchant")

        # @return [:boolean] When true, this is the seller's offer.
        attribute?(:my_offer, :boolean, from: "MyOffer")

        # @return [Points] The number of Amazon Points offered with the purchase of an item.
        attribute?(:points, Points, from: "Points")

        # @return [PrimeInformationType] Amazon Prime information.
        attribute?(:prime_information, PrimeInformationType, from: "PrimeInformation")

        # @return [SellerFeedbackType] Information about the seller's feedback, including the percentage of positive
        #   feedback, and the total number of ratings received.
        attribute?(:seller_feedback_rating, SellerFeedbackType, from: "SellerFeedbackRating")

        # @return [String] The seller identifier for the offer.
        attribute?(:seller_id, String, from: "SellerId")

        # @return [ShipsFromType] The state and country from where the item is shipped.
        attribute?(:ships_from, ShipsFromType, from: "ShipsFrom")

        # @return [String] Indicates the type of customer that the offer is valid for.
        attribute?(:offer_type, String, from: "offerType")

        # @return [Array<QuantityDiscountPriceType>] List of `QuantityDiscountPrice` that contains item's pricing
        #   information when buy in bulk.
        attribute?(:quantity_discount_prices, [QuantityDiscountPriceType], from: "quantityDiscountPrices")
      end
    end
  end
end
