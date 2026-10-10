# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ListingsItems20210801
      # A listings item.
      Item = Structure.new do
        # A selling partner-provided identifier for an Amazon listing.
        attribute(:sku, String, null: false)

        attribute?(:attributes, Hash)

        # The listings item's fulfillment availability.
        attribute?(:fulfillment_availability, [FulfillmentAvailability], from: "fulfillmentAvailability")

        attribute?(:issues, [Issue])

        attribute?(:offers, [ItemOfferByMarketplace])

        # The listings item's vendor procurement information.
        attribute?(:procurement, [ItemProcurement])

        attribute?(:product_types, [ItemProductTypeByMarketplace], from: "productTypes")

        attribute?(:relationships, [ItemRelationshipsByMarketplace])

        attribute?(:summaries, [ItemSummaryByMarketplace])
      end
    end
  end
end
