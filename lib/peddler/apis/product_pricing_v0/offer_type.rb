# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Schema for an individual offer.
      OfferType = Structure.new do
        # Contains pricing information that includes promotions and contains the shipping cost.
        attribute(:buying_price, PriceType, null: false, from: "BuyingPrice")

        # The fulfillment channel for the offer listing. Possible values:
        #
        # * Amazon - Fulfilled by Amazon.
        # * Merchant - Fulfilled by the seller.
        attribute(:fulfillment_channel, String, null: false, from: "FulfillmentChannel")

        # The item condition for the offer listing. Possible values: New, Used, Collectible, Refurbished, or Club.
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        # The item subcondition for the offer listing. Possible values: New, Mint, Very Good, Good, Acceptable, Poor,
        # Club, OEM, Warranty, Refurbished Warranty, Refurbished, Open Box, or Other.
        attribute(:item_sub_condition, String, null: false, from: "ItemSubCondition")

        # The current price excluding any promotions that apply to the product. Excludes the shipping cost.
        attribute(:regular_price, Money, null: false, from: "RegularPrice")

        # The seller stock keeping unit (SKU) of the item.
        attribute(:seller_sku, String, null: false, from: "SellerSKU")

        # The current listing price for Business buyers.
        attribute?(:business_price, Money, from: "businessPrice")

        # Indicates the type of customer that the offer is valid for.
        attribute?(:offer_type, String, from: "offerType")

        # List of `QuantityDiscountPrice` that contains item's pricing information when buy in bulk.
        attribute?(:quantity_discount_prices, [QuantityDiscountPriceType], from: "quantityDiscountPrices")
      end
    end
  end
end
