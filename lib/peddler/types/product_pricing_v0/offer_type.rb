# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/money"
require "peddler/types/product_pricing_v0/price_type"
require "peddler/types/product_pricing_v0/quantity_discount_price_type"

module Peddler
  module Types
    module ProductPricingV0
      # Schema for an individual offer.
      OfferType = Structure.new do
        # @return [PriceType] Contains pricing information that includes promotions and contains the shipping cost.
        attribute(:buying_price, PriceType, from: "BuyingPrice")

        # @return [String] The fulfillment channel for the offer listing. Possible values:
        #
        # * Amazon - Fulfilled by Amazon.
        # * Merchant - Fulfilled by the seller.
        attribute(:fulfillment_channel, String, from: "FulfillmentChannel")

        # @return [String] The item condition for the offer listing. Possible values: New, Used, Collectible,
        # Refurbished, or Club.
        attribute(:item_condition, String, from: "ItemCondition")

        # @return [String] The item subcondition for the offer listing. Possible values: New, Mint, Very Good, Good,
        # Acceptable, Poor, Club, OEM, Warranty, Refurbished Warranty, Refurbished, Open Box, or Other.
        attribute(:item_sub_condition, String, from: "ItemSubCondition")

        # @return [Money] The current price excluding any promotions that apply to the product. Excludes the shipping
        # cost.
        attribute(:regular_price, Money, from: "RegularPrice")

        # @return [String] The seller stock keeping unit (SKU) of the item.
        attribute(:seller_sku, String, from: "SellerSKU")

        # @return [Money] The current listing price for Business buyers.
        attribute?(:business_price, Money, from: "businessPrice")

        # @return [String] Indicates the type of customer that the offer is valid for.
        attribute?(:offer_type, String, from: "offerType")

        # @return [Array<QuantityDiscountPriceType>] List of `QuantityDiscountPrice` that contains item's pricing
        # information when buy in bulk.
        attribute?(:quantity_discount_prices, [QuantityDiscountPriceType], from: "quantityDiscountPrices")
      end
    end
  end
end
