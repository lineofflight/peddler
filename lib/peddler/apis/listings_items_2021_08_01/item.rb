# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # A listings item.
      Item = Structure.new do
        # @return [String] A selling partner-provided identifier for an Amazon listing.
        attribute(:sku, String, null: false)

        # @return [Hash]
        attribute?(:attributes, Hash)

        # @return [Array<FulfillmentAvailability>] The listings item's fulfillment availability.
        attribute?(:fulfillment_availability, [FulfillmentAvailability], from: "fulfillmentAvailability")

        # @return [Array<Issue>]
        attribute?(:issues, [Issue])

        # @return [Array<ItemOfferByMarketplace>]
        attribute?(:offers, [ItemOfferByMarketplace])

        # @return [Array<ItemProcurement>] The listings item's vendor procurement information.
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
