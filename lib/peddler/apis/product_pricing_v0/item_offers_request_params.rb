# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricingV0
      # List of request parameters that can be accepted by `ItemOffersRequest`
      ItemOffersRequestParams = Structure.new do
        # @return [String] Filters the offer listings to be considered based on item condition. Possible values: New,
        #   Used, Collectible, Refurbished, Club.
        attribute(:item_condition, String, from: "ItemCondition")

        # @return [String]
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item. This is the same Asin passed as
        #   a request parameter.
        attribute?(:asin, String, from: "Asin")

        # @return [String] Indicates whether to request Consumer or Business offers. Default is Consumer.
        attribute?(:customer_type, String, from: "CustomerType")
      end
    end
  end
end
