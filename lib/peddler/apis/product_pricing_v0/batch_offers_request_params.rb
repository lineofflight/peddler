# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # Common request parameters that can be accepted by `ItemOffersRequest` and `ListingOffersRequest`
      BatchOffersRequestParams = Structure.new do
        # Filters the offer listings to be considered based on item condition. Possible values: New, Used, Collectible,
        # Refurbished, Club.
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # Indicates whether to request Consumer or Business offers. Default is Consumer.
        attribute?(:customer_type, String, from: "CustomerType")
      end
    end
  end
end
