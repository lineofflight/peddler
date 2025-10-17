# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Details needed to generate the transportation options.
      ShipmentTransportationConfiguration = Structure.new do
        # @return [WindowInput] The range of dates within which the seller intends to ship their items. This is the
        #   pick-up date or 'ready to ship' date, not an estimated delivery date.
        attribute(:ready_to_ship_window, WindowInput, from: "readyToShipWindow")

        # @return [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [ContactInformation]
        attribute?(:contact_information, ContactInformation, from: "contactInformation")

        # @return [FreightInformation]
        attribute?(:freight_information, FreightInformation, from: "freightInformation")

        # @return [Array<PalletInput>] List of pallet configuration inputs.
        attribute?(:pallets, [PalletInput])
      end
    end
  end
end
