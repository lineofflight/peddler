# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorOrdersV1
      # Represents the current status of an order item, including acknowledgement and receiving details.
      OrderItemStatus = Structure.new do
        # @return [String] Numbering of the item on the purchase order. The first item will be 1, the second 2, and so
        #   on.
        attribute(:item_sequence_number, String, null: false, from: "itemSequenceNumber")

        # @return [Hash] Acknowledgement status information.
        attribute?(:acknowledgement_status, Hash, from: "acknowledgementStatus")

        # @return [String] Buyer's Standard Identification Number (ASIN) of an item.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [Money] The list price of an item per each or weight unit.
        attribute?(:list_price, Money, from: "listPrice")

        # @return [Money] The net cost of an item per each or weight unit.
        attribute?(:net_cost, Money, from: "netCost")

        # @return [Hash] Ordered quantity information.
        attribute?(:ordered_quantity, Hash, from: "orderedQuantity")

        # @return [Hash] Item receive status at the buyer's warehouse.
        attribute?(:receiving_status, Hash, from: "receivingStatus")

        # @return [String] The vendor selected product identification of the item.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
