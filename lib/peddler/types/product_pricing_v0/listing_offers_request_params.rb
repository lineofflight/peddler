# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ProductPricingV0
      # List of request parameters that can be accepted by `ListingOffersRequest`
      ListingOffersRequestParams = Structure.new do
        # @return [String]
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] Filters the offer listings to be considered based on item condition. Possible values: New,
        # Used, Collectible, Refurbished, Club.
        attribute(:item_condition, String, from: "ItemCondition")

        # @return [String] Indicates whether to request Consumer or Business offers. Default is Consumer.
        attribute(:customer_type, String, from: "CustomerType")

        # @return [String] The seller stock keeping unit (SKU) of the item. This is the same SKU passed as a path
        # parameter.
        attribute(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
