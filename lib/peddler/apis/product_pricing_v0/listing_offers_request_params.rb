# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # List of request parameters that can be accepted by `ListingOffersRequest`
      ListingOffersRequestParams = Structure.new do
        # Filters the offer listings to be considered based on item condition. Possible values: New, Used, Collectible,
        # Refurbished, Club.
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # The seller stock keeping unit (SKU) of the item. This is the same SKU passed as a path parameter.
        attribute(:seller_sku, String, null: false, from: "SellerSKU")

        # Indicates whether to request Consumer or Business offers. Default is Consumer.
        attribute?(:customer_type, String, from: "CustomerType")
      end
    end
  end
end
