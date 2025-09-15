# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The shipper instruction.
      ShipperInstruction = Structure.new do
        # @return [String] The delivery notes for the shipment
        attribute(:delivery_notes, String, from: "deliveryNotes")
      end
    end
  end
end
