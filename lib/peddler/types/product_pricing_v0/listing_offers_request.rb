# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_pricing_v0/http_request_headers"

module Peddler
  module Types
    module ProductPricingV0
      # List of request parameters that can be accepted by `ListingOffersRequest` operation
      ListingOffersRequest = Structure.new do
        # @return [String] Filters the offer listings to be considered based on item condition. Possible values: New,
        # Used, Collectible, Refurbished, Club.
        attribute(:item_condition, String, from: "ItemCondition")

        # @return [String]
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String]
        attribute(:method, String)

        # @return [String] The resource path of the operation you are calling in batch without any query parameters.
        #
        # If you are calling `getItemOffersBatch`, supply the path of `getItemOffers`.
        #
        # **Example:** `/products/pricing/v0/items/B000P6Q7MY/offers`
        #
        # If you are calling `getListingOffersBatch`, supply the path of `getListingOffers`.
        #
        # **Example:** `/products/pricing/v0/listings/B000P6Q7MY/offers`
        attribute(:uri, String)

        # @return [String] Indicates whether to request Consumer or Business offers. Default is Consumer.
        attribute?(:customer_type, String, from: "CustomerType")

        # @return [HttpRequestHeaders]
        attribute?(:headers, HttpRequestHeaders)
      end
    end
  end
end
