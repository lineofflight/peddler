# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/address"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Specifies the 'ship from' address for the shipment.
      ShipmentSource = Structure.new do
        # @return [Address]
        attribute(:address, Address)

        # @return [String] The type of source for this shipment. Possible values: `SELLER_FACILITY`.
        attribute(:source_type, String, from: "sourceType")
      end
    end
  end
end
