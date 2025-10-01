# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_direct_fulfillment_orders_v1/party_identification"
require "peddler/types/vendor_direct_fulfillment_orders_v1/order_item"
require "peddler/types/vendor_direct_fulfillment_orders_v1/address"
require "peddler/types/vendor_direct_fulfillment_orders_v1/shipment_details"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # Details of an order.
      OrderDetails = Structure.new do
        # @return [PartyIdentification] Name/Address and tax details of the bill to party.
        attribute(:bill_to_party, PartyIdentification, from: "billToParty")

        # @return [String] The customer order number.
        attribute(:customer_order_number, String, from: "customerOrderNumber")

        # @return [Array<OrderItem>] A list of items in this purchase order.
        attribute(:items, [OrderItem])

        # @return [String] The date the order was placed. This field is expected to be in ISO-8601 date/time format, for
        # example:2018-07-16T23:00:00Z/ 2018-07-16T23:00:00-05:00 /2018-07-16T23:00:00-08:00. If no time zone is
        # specified, UTC should be assumed.
        attribute(:order_date, String, from: "orderDate")

        # @return [PartyIdentification] PartyID of vendor code.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] PartyID of vendor's warehouse.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [Address] Name/Address and tax details of the ship to party.
        attribute(:ship_to_party, Address, from: "shipToParty")

        # @return [ShipmentDetails]
        attribute(:shipment_details, ShipmentDetails, from: "shipmentDetails")

        # @return [String] Current status of the order.
        attribute?(:order_status, String, from: "orderStatus")

        # @return [Hash] The total Tax object within shipment that relates to the order.
        attribute?(:tax_total, Hash, from: "taxTotal")
      end
    end
  end
end
