# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ServicesV1
      # Information about an item associated with the service job.
      AssociatedItem = Structure.new do
        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # The brand name of the item.
        attribute?(:brand_name, String, from: "brandName")

        # Delivery information for the item.
        attribute?(:item_delivery, ItemDelivery, from: "itemDelivery")

        # The status of the item. Known values: `ACTIVE`, `CANCELLED`, `SHIPPED`, `DELIVERED`.
        attribute?(:item_status, String, from: "itemStatus")

        # A list of customer-owned assets on which the service must be performed.
        attribute?(:linked_assets, [LinkedAsset], from: "linkedAssets")

        # The Amazon-defined identifier for an order placed by the buyer in 3-7-7 format.
        attribute?(:order_id, String, from: "orderId")

        # The total number of items included in the order.
        attribute?(:quantity, Integer)

        # The title of the item.
        attribute?(:title, String)
      end
    end
  end
end
