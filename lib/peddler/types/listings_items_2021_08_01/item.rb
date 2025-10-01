# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/listings_items_2021_08_01/item_attributes"
require "peddler/types/listings_items_2021_08_01/fulfillment_availability"
require "peddler/types/listings_items_2021_08_01/issue"
require "peddler/types/listings_items_2021_08_01/item_offer_by_marketplace"
require "peddler/types/listings_items_2021_08_01/item_procurement"
require "peddler/types/listings_items_2021_08_01/item_product_type_by_marketplace"
require "peddler/types/listings_items_2021_08_01/item_relationships_by_marketplace"
require "peddler/types/listings_items_2021_08_01/item_summary_by_marketplace"

module Peddler
  module Types
    module ListingsItems20210801
      # A listings item.
      Item = Structure.new do
        # @return [String] A selling partner provided identifier for an Amazon listing.
        attribute(:sku, String)

        # @return [ItemAttributes]
        attribute?(:attributes, ItemAttributes)

        # @return [Array<FulfillmentAvailability>] The fulfillment availability for the listings item.
        attribute?(:fulfillment_availability, [FulfillmentAvailability], from: "fulfillmentAvailability")

        # @return [Array<Issue>]
        attribute?(:issues, [Issue])

        # @return [Array<ItemOfferByMarketplace>]
        attribute?(:offers, [ItemOfferByMarketplace])

        # @return [Array<ItemProcurement>] The vendor procurement information for the listings item.
        attribute?(:procurement, [ItemProcurement])

        # @return [Array<ItemProductTypeByMarketplace>]
        attribute?(:product_types, [ItemProductTypeByMarketplace], from: "productTypes")

        # @return [Array<ItemRelationshipsByMarketplace>]
        attribute?(:relationships, [ItemRelationshipsByMarketplace])

        # @return [Array<ItemSummaryByMarketplace>]
        attribute?(:summaries, [ItemSummaryByMarketplace])
      end
    end
  end
end
