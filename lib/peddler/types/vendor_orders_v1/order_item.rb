# frozen_string_literal: true

require "peddler/money"
require "peddler/types/vendor_orders_v1/item_quantity"

module Peddler
  module Types
    module VendorOrdersV1
      # Represents an individual item in an order, including item details, quantities, pricing, and backorder
      # information.
      OrderItem = Structure.new do
        # @return [String] Numbering of the item on the purchase order. The first item will be 1, the second 2, and so
        # on.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [String] Amazon Standard Identification Number (ASIN) of an item.
        attribute(:amazon_product_identifier, String, from: "amazonProductIdentifier")

        # @return [String] The vendor selected product identification of the item.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] Item quantity ordered.
        attribute(:ordered_quantity, ItemQuantity, from: "orderedQuantity")

        # @return [:boolean] When true, we will accept backorder confirmations for this item.
        attribute(:back_order_allowed, :boolean, from: "isBackOrderAllowed")

        # @return [Money] The net cost of an item per each or weight unit.
        attribute(:net_cost, Money, from: "netCost")

        # @return [Money] The list price of an item per each or weight unit.
        attribute(:list_price, Money, from: "listPrice")
      end
    end
  end
end
