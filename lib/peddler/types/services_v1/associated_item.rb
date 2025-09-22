# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/item_delivery"

module Peddler
  module Types
    module ServicesV1
      # Information about an item associated with the service job.
      AssociatedItem = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String)

        # @return [String] The title of the item.
        attribute(:title, String)

        # @return [Integer] The total number of items included in the order.
        attribute(:quantity, Integer)

        # @return [String] The Amazon-defined identifier for an order placed by the buyer in 3-7-7 format.
        attribute(:order_id, String, from: "orderId")

        # @return [String] The status of the item.
        attribute(:item_status, String, from: "itemStatus")

        # @return [String] The brand name of the item.
        attribute(:brand_name, String, from: "brandName")

        # @return [ItemDelivery] Delivery information for the item.
        attribute(:item_delivery, ItemDelivery, from: "itemDelivery")
      end
    end
  end
end
