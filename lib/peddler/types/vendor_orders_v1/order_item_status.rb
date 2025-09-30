# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "structure"

module Peddler
  module Types
    module VendorOrdersV1
      # Represents the current status of an order item, including acknowledgement and receiving details.
      OrderItemStatus = Structure.new do
        # @return [String] Numbering of the item on the purchase order. The first item will be 1, the second 2, and so
        # on.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [String] Buyer's Standard Identification Number (ASIN) of an item.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [Money] The net cost of an item per each or weight unit.
        attribute?(:net_cost, Money, from: "netCost")

        # @return [Money] The list price of an item per each or weight unit.
        attribute?(:list_price, Money, from: "listPrice")

        # @return [Hash] Ordered quantity information.
        attribute?(:ordered_quantity, Hash, from: "orderedQuantity")

        # @return [Hash] Acknowledgement status information.
        attribute?(:acknowledgement_status, Hash, from: "acknowledgementStatus")

        # @return [Hash] Item receive status at the buyer's warehouse.
        attribute?(:receiving_status, Hash, from: "receivingStatus")
      end
    end
  end
end
