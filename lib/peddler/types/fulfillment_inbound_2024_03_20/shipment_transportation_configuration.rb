# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/contact_information"
require "peddler/types/fulfillment_inbound_2024_03_20/freight_information"
require "peddler/types/fulfillment_inbound_2024_03_20/pallet_input"
require "peddler/types/fulfillment_inbound_2024_03_20/window_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Details needed to generate the transportation options.
      ShipmentTransportationConfiguration = Structure.new do
        # @return [ContactInformation]
        attribute?(:contact_information, ContactInformation, from: "contactInformation")

        # @return [FreightInformation]
        attribute?(:freight_information, FreightInformation, from: "freightInformation")

        # @return [Array<PalletInput>] List of pallet configuration inputs.
        attribute?(:pallets, [PalletInput])

        # @return [WindowInput] The range of dates within which the seller intends to ship their items. This is the
        # pick-up date or 'ready to ship' date, not an estimated delivery date.
        attribute(:ready_to_ship_window, WindowInput, from: "readyToShipWindow")

        # @return [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
        attribute(:shipment_id, String, from: "shipmentId")
      end
    end
  end
end
