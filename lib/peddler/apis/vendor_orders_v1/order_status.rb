# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorOrdersV1
      # Current status of a purchase order.
      OrderStatus = Structure.new do
        # @return [Array<OrderItemStatus>] Detailed order status.
        attribute(:item_status, [OrderItemStatus], from: "itemStatus")

        # @return [Time] The date the purchase order was placed. Must be in ISO-8601 date/time format.
        attribute(:purchase_order_date, Time, from: "purchaseOrderDate")

        # @return [String] The buyer's purchase order number for this order. Formatting Notes: 8-character alpha-numeric
        #   code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [String] The status of the buyer's purchase order for this order.
        attribute(:purchase_order_status, String, from: "purchaseOrderStatus")

        # @return [PartyIdentification] Name/Address and tax details of the selling party.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Name/Address and tax details of the ship to party. Find a list of fulfillment
        #   center addresses for a region on the [Resources page of Amazon Vendor
        #   Central](https://vendorcentral.amazon.com/hz/vendor/members/support/help/node/GPZ88XH8HQM97ZV6).
        attribute(:ship_to_party, PartyIdentification, from: "shipToParty")

        # @return [Time] The date when the purchase order was last updated. Must be in ISO-8601 date/time format.
        attribute?(:last_updated_date, Time, from: "lastUpdatedDate")
      end
    end
  end
end
