# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The Amazon fulfillment center address and warehouse ID.
      ShipmentDestination = Structure.new do
        # @return [String] The type of destination for this shipment. Possible values: `AMAZON_OPTIMIZED`,
        # `AMAZON_WAREHOUSE`.
        attribute(:destination_type, String, from: "destinationType")

        # @return [Address] The address the shipment should be sent to. This can be empty if the destination type is
        # `AMAZON_OPTIMIZED`.
        attribute?(:address, Address)

        # @return [String] The warehouse that the shipment should be sent to. This can be empty if the destination type
        # is `AMAZON_OPTIMIZED`.
        attribute?(:warehouse_id, String, from: "warehouseId")
      end
    end
  end
end
