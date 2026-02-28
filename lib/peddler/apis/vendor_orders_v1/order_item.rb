# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorOrdersV1
      # Represents an individual item in an order, including item details, quantities, pricing, and backorder
      # information.
      OrderItem = Structure.new do
        # @return [:boolean] When true, we will accept backorder confirmations for this item.
        attribute(:back_order_allowed, :boolean, null: false, from: "isBackOrderAllowed")

        # @return [String] Numbering of the item on the purchase order. The first item will be 1, the second 2, and so
        #   on.
        attribute(:item_sequence_number, String, null: false, from: "itemSequenceNumber")

        # @return [ItemQuantity] Item quantity ordered.
        attribute(:ordered_quantity, ItemQuantity, null: false, from: "orderedQuantity")

        # @return [String] Amazon Standard Identification Number (ASIN) of an item.
        attribute?(:amazon_product_identifier, String, from: "amazonProductIdentifier")

        # @return [Money] The list price of an item per each or weight unit.
        attribute?(:list_price, Money, from: "listPrice")

        # @return [Money] The net cost of an item per each or weight unit.
        attribute?(:net_cost, Money, from: "netCost")

        # @return [String] The vendor selected product identification of the item.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
