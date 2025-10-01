# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The shipper instruction.
      ShipperInstruction = Structure.new do
        # @return [String] The delivery notes for the shipment
        attribute?(:delivery_notes, String, from: "deliveryNotes")
      end
    end
  end
end
