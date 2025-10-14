# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Specifies the 'ship from' address for the shipment.
      ShipmentSource = Structure.new do
        # @return [String] The type of source for this shipment. Possible values: `SELLER_FACILITY`.
        attribute(:source_type, String, from: "sourceType")

        # @return [Address]
        attribute?(:address, Address)
      end
    end
  end
end
