# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/shipment_details"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/tax_item_details"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/party_identification"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/address"
require "peddler/types/vendor_direct_fulfillment_orders_2021_12_28/order_item"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Details of an order.
      OrderDetails = Structure.new do
        # @return [String] The customer order number.
        attribute(:customer_order_number, String, from: "customerOrderNumber")

        # @return [String] The date the order was placed. This field is expected to be in ISO-8601 date/time format, for
        # example:2018-07-16T23:00:00Z/ 2018-07-16T23:00:00-05:00 /2018-07-16T23:00:00-08:00. If no time zone is
        # specified, UTC should be assumed.
        attribute(:order_date, String, from: "orderDate")

        # @return [String] Current status of the order.
        attribute(:order_status, String, from: "orderStatus")

        # @return [ShipmentDetails]
        attribute(:shipment_details, ShipmentDetails, from: "shipmentDetails")

        # @return [TaxItemDetails]
        attribute(:tax_total, TaxItemDetails, from: "taxTotal")

        # @return [PartyIdentification] PartyID of vendor code.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] PartyID of vendor's warehouse.
        attribute(:ship_from_party, PartyIdentification, from: "shipFromParty")

        # @return [Address] Name/Address and tax details of the ship to party.
        attribute(:ship_to_party, Address, from: "shipToParty")

        # @return [PartyIdentification] Name/Address and tax details of the bill to party.
        attribute(:bill_to_party, PartyIdentification, from: "billToParty")

        # @return [Array<OrderItem>] A list of items in this purchase order.
        attribute(:items, [OrderItem])
      end
    end
  end
end
