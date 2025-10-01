# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_orders_v1/order_acknowledgement_item"
require "peddler/types/vendor_orders_v1/party_identification"

module Peddler
  module Types
    module VendorOrdersV1
      # Represents an acknowledgement for an order, including the purchase order number, selling party details,
      # acknowledgement date, and a list of acknowledged items.
      OrderAcknowledgement = Structure.new do
        # @return [String] The date and time when the purchase order is acknowledged, in ISO-8601 date/time format.
        attribute(:acknowledgement_date, String, from: "acknowledgementDate")

        # @return [Array<OrderAcknowledgementItem>] A list of the items being acknowledged with associated details.
        attribute(:items, [OrderAcknowledgementItem])

        # @return [String] The purchase order number. Formatting Notes: 8-character alpha-numeric code.
        attribute(:purchase_order_number, String, from: "purchaseOrderNumber")

        # @return [PartyIdentification] Name, address and tax details of the party receiving a shipment of products.
        attribute(:selling_party, PartyIdentification, from: "sellingParty")
      end
    end
  end
end
