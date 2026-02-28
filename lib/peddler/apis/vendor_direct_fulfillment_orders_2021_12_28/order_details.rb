# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorDirectFulfillmentOrders20211228
      # Details of an order.
      OrderDetails = Structure.new do
        # @return [PartyIdentification] Name/Address and tax details of the bill to party.
        attribute(:bill_to_party, PartyIdentification, null: false, from: "billToParty")

        # @return [String] The customer order number.
        attribute(:customer_order_number, String, null: false, from: "customerOrderNumber")

        # @return [Array<OrderItem>] A list of items in this purchase order.
        attribute(:items, [OrderItem], null: false)

        # @return [Time] The date the order was placed. This field is expected to be in ISO-8601 date/time format, for
        #   example:2018-07-16T23:00:00Z/ 2018-07-16T23:00:00-05:00 /2018-07-16T23:00:00-08:00. If no time zone is
        #   specified, UTC should be assumed.
        attribute(:order_date, Time, null: false, from: "orderDate")

        # @return [PartyIdentification] PartyID of vendor code.
        attribute(:selling_party, PartyIdentification, null: false, from: "sellingParty")

        # @return [PartyIdentification] PartyID of vendor's warehouse.
        attribute(:ship_from_party, PartyIdentification, null: false, from: "shipFromParty")

        # @return [Address] Name/Address and tax details of the ship to party.
        attribute(:ship_to_party, Address, null: false, from: "shipToParty")

        # @return [ShipmentDetails]
        attribute(:shipment_details, ShipmentDetails, null: false, from: "shipmentDetails")

        # @return [:boolean] When `true`, the order contains customizable items.
        attribute?(:has_customizable_items, :boolean, from: "hasCustomizableItems")

        # @return [String] Current status of the order.
        attribute?(:order_status, String, from: "orderStatus")

        # @return [TaxItemDetails]
        attribute?(:tax_total, TaxItemDetails, from: "taxTotal")
      end
    end
  end
end
