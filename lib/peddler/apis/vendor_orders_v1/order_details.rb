# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorOrdersV1
      # Details of an order.
      OrderDetails = Structure.new do
        # @return [Array<OrderItem>] A list of items in this purchase order.
        attribute(:items, [OrderItem])

        # @return [Time] The date the purchase order was placed. Must be in ISO-8601 date/time format.
        attribute(:purchase_order_date, Time, from: "purchaseOrderDate")

        # @return [Time] The date when current purchase order state was changed. Current purchase order state is
        # available in the field 'purchaseOrderState'. Must be in ISO-8601 date/time format.
        attribute(:purchase_order_state_changed_date, Time, from: "purchaseOrderStateChangedDate")

        # @return [PartyIdentification] Name/Address and tax details of the bill to party.
        attribute?(:bill_to_party, PartyIdentification, from: "billToParty")

        # @return [PartyIdentification] Name/Address and tax details of the buying party.
        attribute?(:buying_party, PartyIdentification, from: "buyingParty")

        # @return [String] If requested by the recipient, this field will contain a promotional/deal number. The
        # discount code line is optional. It is used to obtain a price discount on items on the order.
        attribute?(:deal_code, String, from: "dealCode")

        # @return [String] This indicates the delivery window. Format is start and end date separated by double hyphen
        # (--). For example, 2007-03-01T13:00:00Z--2007-03-11T15:30:00Z.
        attribute?(:delivery_window, String, from: "deliveryWindow")

        # @return [ImportDetails] If the purchase order is an import order, the details for the import order.
        attribute?(:import_details, ImportDetails, from: "importDetails")

        # @return [String] Payment method used.
        attribute?(:payment_method, String, from: "paymentMethod")

        # @return [Time] The date when purchase order was last changed by Amazon after the order was placed. This date
        # will be greater than 'purchaseOrderDate'. This means the PO data was changed on that date and vendors are
        # required to fulfill the updated PO. The PO changes can be related to Item Quantity, Ship to Location, Ship
        # Window etc. This field will not be present in orders that have not changed after creation. Must be in ISO-8601
        # date/time format.
        attribute?(:purchase_order_changed_date, Time, from: "purchaseOrderChangedDate")

        # @return [String] Type of purchase order.
        attribute?(:purchase_order_type, String, from: "purchaseOrderType")

        # @return [PartyIdentification] Name/Address and tax details of the selling party.
        attribute?(:selling_party, PartyIdentification, from: "sellingParty")

        # @return [PartyIdentification] Name/Address and tax details of the ship to party. Find a list of fulfillment
        # center addresses for a region on the [Resources page of Amazon Vendor
        # Central](https://vendorcentral.amazon.com/hz/vendor/members/support/help/node/GPZ88XH8HQM97ZV6).
        attribute?(:ship_to_party, PartyIdentification, from: "shipToParty")

        # @return [String] This indicates the ship window. Format is start and end date separated by double hyphen (--).
        # For example, 2007-03-01T13:00:00Z--2007-03-11T15:30:00Z.
        attribute?(:ship_window, String, from: "shipWindow")
      end
    end
  end
end
