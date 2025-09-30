# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/product_pricing_v0/item_identifier"
require "peddler/types/product_pricing_v0/summary"
require "peddler/types/product_pricing_v0/offer_detail"

module Peddler
  module Types
    module ProductPricingV0
      # The payload for the getListingOffers and getItemOffers operations.
      GetOffersResult = Structure.new do
        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceID")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # @return [String] The stock keeping unit (SKU) of the item.
        attribute?(:sku, String, from: "SKU")

        # @return [String] The condition of the item.
        attribute(:item_condition, String, from: "ItemCondition")

        # @return [String] The status of the operation.
        attribute(:status, String)

        # @return [ItemIdentifier] Metadata that identifies the item.
        attribute(:identifier, ItemIdentifier, from: "Identifier")

        # @return [Summary] Pricing information about the item.
        attribute(:summary, Summary, from: "Summary")

        # @return [Array<OfferDetail>] A list of offer details. The list is the same length as the TotalOfferCount in
        # the Summary or 20, whichever is less.
        attribute(:offers, [OfferDetail], from: "Offers")
      end
    end
  end
end
