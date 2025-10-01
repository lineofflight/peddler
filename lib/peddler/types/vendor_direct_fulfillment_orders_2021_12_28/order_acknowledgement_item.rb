# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/acknowledgement_status"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/order_item_acknowledgement"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/party_identification"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Details of an individual order being acknowledged.
      OrderAcknowledgementItem = Structure.new do
        # @return [String] The date and time when the order is acknowledged, in ISO-8601 date/time format. For example:
        # 2018-07-16T23:00:00Z / 2018-07-16T23:00:00-05:00 / 2018-07-16T23:00:00-08:00.
        attribute(:acknowledgement_date, String, from: "acknowledgementDate")

        # @return [AcknowledgementStatus] Status of acknowledgement.
        attribute(:acknowledgement_status, AcknowledgementStatus, from: "acknowledgementStatus")

        # @return [Array<OrderItemAcknowledgement>] Item details including acknowledged quantity.
        attribute(:item_acknowledgements, [OrderItemAcknowledgement], from: "itemAcknowledgements")

        # @return [String] The purchase order number for this order. Formatting Notes: alpha-numeric code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] PartyID as vendor code.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] PartyID as the vendor's warehouseId.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [String] The vendor's order number for this order.
        attribute(:vendor_order_number, String, from: "vendorOrderNumber")
      end
    end
  end
end
