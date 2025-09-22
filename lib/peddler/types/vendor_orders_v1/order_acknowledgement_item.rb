# frozen_string_literal: true

require "peddler/types/money"
require "peddler/types/vendor_orders_v1/item_quantity"
require "peddler/types/vendor_orders_v1/order_item_acknowledgement"

module Peddler
  module Types
    module VendorOrdersV1
      # Details of the item being acknowledged.
      OrderAcknowledgementItem = Structure.new do
        # @return [String] Line item sequence number for the item.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [String] Amazon Standard Identification Number (ASIN) of an item.
        attribute(:amazon_product_identifier, String, from: "amazonProductIdentifier")

        # @return [String] The vendor selected product identification of the item. Should be the same as was sent in the
        # purchase order.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [ItemQuantity] The quantity of this item ordered.
        attribute(:ordered_quantity, ItemQuantity, from: "orderedQuantity")

        # @return [Types::Money] The net cost of an item per each or weight unit that must match the cost on the
        # invoice. This is a required field. If left blank, Amazon systems will reject the file. Price information must
        # not be zero or negative.
        attribute(:net_cost, Types::Money, from: "netCost")

        # @return [Types::Money] The list price of an item per each or weight unit. Required only if a vendor sells
        # books at list price.
        attribute(:list_price, Types::Money, from: "listPrice")

        # @return [String] The discount multiplier that should be applied to the price if a vendor sells books with a
        # list price. This is a multiplier factor to arrive at a final discounted price. A multiplier of .90 would be
        # the factor if a 10% discount is given.
        attribute(:discount_multiplier, String, from: "discountMultiplier")

        # @return [Array<OrderItemAcknowledgement>] This is used to indicate acknowledged quantity.
        attribute(:item_acknowledgements, [OrderItemAcknowledgement], from: "itemAcknowledgements")
      end
    end
  end
end
