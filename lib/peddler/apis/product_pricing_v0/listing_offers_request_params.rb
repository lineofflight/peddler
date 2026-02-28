# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # List of request parameters that can be accepted by `ListingOffersRequest`
      ListingOffersRequestParams = Structure.new do
        # @return [String] Filters the offer listings to be considered based on item condition. Possible values: New,
        #   Used, Collectible, Refurbished, Club.
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        # @return [String]
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # @return [String] The seller stock keeping unit (SKU) of the item. This is the same SKU passed as a path
        #   parameter.
        attribute(:seller_sku, String, null: false, from: "SellerSKU")

        # @return [String] Indicates whether to request Consumer or Business offers. Default is Consumer.
        attribute?(:customer_type, String, from: "CustomerType")
      end
    end
  end
end
