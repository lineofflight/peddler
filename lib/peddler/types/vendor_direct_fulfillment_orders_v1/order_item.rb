# frozen_string_literal: true

require "peddler/money"
require "peddler/types/vendor_direct_fulfillment_orders_v1/item_quantity"
require "peddler/types/vendor_direct_fulfillment_orders_v1/scheduled_delivery_shipment"
require "peddler/types/vendor_direct_fulfillment_orders_v1/gift_details"

module Peddler
  module Types
    module VendorDirectFulfillmentOrdersV1
      # An item within an order
      OrderItem = Structure.new do
        # @return [String] Numbering of the item on the purchase order. The first item will be 1, the second 2, and so
        # on.
        attribute(:item_sequence_number, String, from: "itemSequenceNumber")

        # @return [String] Buyer's standard identification number (ASIN) of an item.
        attribute(:buyer_product_identifier, String, from: "buyerProductIdentifier")

        # @return [String] The vendor selected product identification of the item.
        attribute(:vendor_product_identifier, String, from: "vendorProductIdentifier")

        # @return [String] Title for the item.
        attribute(:title, String)

        # @return [ItemQuantity] Item quantity ordered.
        attribute(:ordered_quantity, ItemQuantity, from: "orderedQuantity")

        # @return [ScheduledDeliveryShipment] Details for the scheduled delivery shipment.
        attribute(:scheduled_delivery_shipment, ScheduledDeliveryShipment, from: "scheduledDeliveryShipment")

        # @return [GiftDetails] Gift message and wrapId details.
        attribute(:gift_details, GiftDetails, from: "giftDetails")

        # @return [Money] Net price (before tax) to vendor with currency details.
        attribute(:net_price, Money, from: "netPrice")

        # @return [Hash] Total tax details for the line item.
        attribute(:tax_details, Hash, from: "taxDetails")

        # @return [Money] The price to Amazon each (cost).
        attribute(:total_price, Money, from: "totalPrice")
      end
    end
  end
end
