# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorDirectFulfillmentOrdersV1
      # An item within an order
      OrderItem = Structure.new do
        # Numbering of the item on the purchase order. The first item will be 1, the second 2, and so on.
        attribute(:item_sequence_number, String, null: false, from: "itemSequenceNumber")

        # Net price (before tax) to vendor with currency details.
        attribute(:net_price, Money, null: false, from: "netPrice")

        # Item quantity ordered.
        attribute(:ordered_quantity, ItemQuantity, null: false, from: "orderedQuantity")

        # Buyer's standard identification number (ASIN) of an item.
        attribute?(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # Gift message and wrapId details.
        attribute?(:gift_details, GiftDetails, from: "giftDetails")

        # Details for the scheduled delivery shipment.
        attribute?(:scheduled_delivery_shipment, ScheduledDeliveryShipment, from: "scheduledDeliveryShipment")

        # Total tax details for the line item.
        attribute?(:tax_details, TaxDetails, from: "taxDetails")

        # Title for the item.
        attribute?(:title, String)

        # The price to Amazon each (cost).
        attribute?(:total_price, Money, from: "totalPrice")

        # The vendor selected product identification of the item.
        attribute?(:vendor_product_identifier, String, from: "vendorProductIdentifier")
      end
    end
  end
end
