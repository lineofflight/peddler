# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInboundV0
      # Result for the get shipment items operation
      GetShipmentItemsResult = Structure.new do
        # @return [Array<InboundShipmentItem>] A list of item information for an inbound shipment.
        attribute?(:item_data, [InboundShipmentItem], from: "ItemData")

        # @return [String] When present and not empty, pass this string token in the next request to return the next
        # response page.
        attribute?(:next_token, String, from: "NextToken")
      end
    end
  end
end
