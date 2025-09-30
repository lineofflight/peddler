# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/address"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The Amazon fulfillment center address and warehouse ID.
      ShipmentDestination = Structure.new do
        # @return [Address] The address the shipment should be sent to. This can be empty if the destination type is
        # `AMAZON_OPTIMIZED`.
        attribute?(:address, Address)

        # @return [String] The type of destination for this shipment. Possible values: `AMAZON_OPTIMIZED`,
        # `AMAZON_WAREHOUSE`.
        attribute(:destination_type, String, from: "destinationType")

        # @return [String] The warehouse that the shipment should be sent to. This can be empty if the destination type
        # is `AMAZON_OPTIMIZED`.
        attribute?(:warehouse_id, String, from: "warehouseId")
      end
    end
  end
end
