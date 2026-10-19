# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductPricingV0
      # The payload for the getListingOffers and getItemOffers operations.
      GetOffersResult = Structure.new do
        # Metadata that identifies the item.
        attribute(:identifier, ItemIdentifier, null: false, from: "Identifier")

        # The condition of the item. Known values: `New`, `Used`, `Collectible`, `Refurbished`, `Club`.
        attribute(:item_condition, String, null: false, from: "ItemCondition")

        # A list of offer details. The list is the same length as the TotalOfferCount in the Summary or 20, whichever is
        # less.
        attribute(:offers, [OfferDetail], null: false, from: "Offers")

        # Pricing information about the item.
        attribute(:summary, Summary, null: false, from: "Summary")

        # A marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # The status of the operation.
        attribute(:status, String, null: false)

        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String, from: "ASIN")

        # The stock keeping unit (SKU) of the item.
        attribute?(:sku, String, from: "SKU")
      end
    end
  end
end
