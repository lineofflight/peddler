# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Amazon shipment information.
      AmazonShipmentDetails = Structure.new do
        # @return [String] This attribute is required only for a Direct Fulfillment shipment. This is the encrypted
        # shipment ID.
        attribute(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
