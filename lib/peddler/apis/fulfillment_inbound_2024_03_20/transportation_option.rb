# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Contains information pertaining to a transportation option and the related carrier.
      TransportationOption = Structure.new do
        # @return [Carrier]
        attribute(:carrier, Carrier, null: false)

        # @return [Array<String>] Identifies a list of preconditions for confirming the transportation option.
        attribute(:preconditions, [String], null: false)

        # @return [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
        attribute(:shipment_id, String, null: false, from: "shipmentId")

        # @return [String] Mode of shipment transportation that this option will provide.
        #
        # Possible values: `GROUND_SMALL_PARCEL`, `FREIGHT_LTL`, `FREIGHT_FTL_PALLET`, `FREIGHT_FTL_NONPALLET`,
        #   `OCEAN_LCL`, `OCEAN_FCL`, `AIR_SMALL_PARCEL`, `AIR_SMALL_PARCEL_EXPRESS`.
        attribute(:shipping_mode, String, null: false, from: "shippingMode")

        # @return [String] Shipping program for the option. Possible values: `AMAZON_PARTNERED_CARRIER`,
        #   `USE_YOUR_OWN_CARRIER`.
        attribute(:shipping_solution, String, null: false, from: "shippingSolution")

        # @return [String] Identifier of a transportation option. A transportation option represent one option for how
        #   to send a shipment.
        attribute(:transportation_option_id, String, null: false, from: "transportationOptionId")

        # @return [CarrierAppointment]
        attribute?(:carrier_appointment, CarrierAppointment, from: "carrierAppointment")

        # @return [Quote]
        attribute?(:quote, Quote)
      end
    end
  end
end
