# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Information about an item associated with the service job.
      AssociatedItem = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute?(:asin, String)

        # @return [String] The brand name of the item.
        attribute?(:brand_name, String, from: "brandName")

        # @return [ItemDelivery] Delivery information for the item.
        attribute?(:item_delivery, ItemDelivery, from: "itemDelivery")

        # @return [String] The status of the item.
        attribute?(:item_status, String, from: "itemStatus")

        # @return [String] The Amazon-defined identifier for an order placed by the buyer in 3-7-7 format.
        attribute?(:order_id, String, from: "orderId")

        # @return [Integer] The total number of items included in the order.
        attribute?(:quantity, Integer)

        # @return [String] The title of the item.
        attribute?(:title, String)
      end
    end
  end
end
