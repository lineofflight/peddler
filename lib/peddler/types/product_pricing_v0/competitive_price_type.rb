# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/price_type"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for competitive pricing information
      CompetitivePriceType = Structure.new do
        # @return [String] The pricing model for each price that is returned.
        #
        # Possible values:
        #
        # * 1 - New Buy Box Price.
        # * 2 - Used Buy Box Price.
        attribute(:competitive_price_id, String, from: "CompetitivePriceId")

        # @return [PriceType] Pricing information for a given CompetitivePriceId value.
        attribute(:price, PriceType, from: "Price")

        # @return [String] Indicates the condition of the item whose pricing information is returned. Possible values
        # are: New, Used, Collectible, Refurbished, or Club.
        attribute(:condition, String)

        # @return [String] Indicates the subcondition of the item whose pricing information is returned. Possible values
        # are: New, Mint, Very Good, Good, Acceptable, Poor, Club, OEM, Warranty, Refurbished Warranty, Refurbished,
        # Open Box, or Other.
        attribute(:subcondition, String)

        # @return [String] Indicates the type of customer that the offer is valid for.<br><br>When the offer type is B2C
        # in a quantity discount, the seller is winning the Buy Box because others do not have inventory at that
        # quantity, not because they have a quantity discount on the ASIN.
        attribute(:offer_type, String, from: "offerType")

        # @return [Integer] Indicates at what quantity this price becomes active.
        attribute(:quantity_tier, Integer, from: "quantityTier")

        # @return [String] Indicates the type of quantity discount this price applies to.
        attribute(:quantity_discount_type, String, from: "quantityDiscountType")

        # @return [String] The seller identifier for the offer.
        attribute(:seller_id, String, from: "sellerId")

        # @return [:boolean] Indicates whether or not the pricing information is for an offer listing that belongs to
        # the requester. The requester is the seller associated with the SellerId that was submitted with the request.
        # Possible values are: true and false.
        attribute(:belongs_to_requester, :boolean, from: "belongsToRequester")
      end
    end
  end
end
