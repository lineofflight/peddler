# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_orders_v1/party_identification"
require "peddler/types/vendor_orders_v1/order_item_status"

module Peddler
  module Types
    module VendorOrdersV1
      # Current status of a purchase order.
      OrderStatus = Structure.new do
        # @return [String] The buyer's purchase order number for this order. Formatting Notes: 8-character alpha-numeric
        # code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] The status of the buyer's purchase order for this order.
        attribute(:purchase_order_status, String, from: "purchaseOrderStatus")

        # @return [String] The date the purchase order was placed. Must be in ISO-8601 date/time format.
        attribute(:purchase_order_date, String, from: "purchaseOrderDate")

        # @return [String] The date when the purchase order was last updated. Must be in ISO-8601 date/time format.
        attribute?(:last_updated_date, String, from: "lastUpdatedDate")

        # @return [PartyIdentification] Name/Address and tax details of the selling party.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Name/Address and tax details of the ship to party. Find a list of fulfillment
        # center addresses for a region on the [Resources page of Amazon Vendor
        # Central](https://vendorcentral.amazon.com/hz/vendor/members/support/help/node/GPZ88XH8HQM97ZV6).
        attribute(:ship_to_party, PartyIdentification, from: "shipToParty")

        # @return [Array<OrderItemStatus>] Detailed order status.
        attribute(:item_status, [OrderItemStatus], from: "itemStatus")
      end
    end
  end
end
