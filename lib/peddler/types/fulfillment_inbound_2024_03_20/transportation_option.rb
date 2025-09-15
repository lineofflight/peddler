# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/carrier"
require "peddler/types/fulfillment_inbound_2024_03_20/carrier_appointment"
require "peddler/types/fulfillment_inbound_2024_03_20/quote"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Contains information pertaining to a transportation option and the related carrier.
      TransportationOption = Structure.new do
        # @return [Carrier]
        attribute(:carrier, Carrier)

        # @return [CarrierAppointment]
        attribute(:carrier_appointment, CarrierAppointment, from: "carrierAppointment")

        # @return [Array<String>] Identifies a list of preconditions for confirming the transportation option.
        attribute(:preconditions, [String])

        # @return [Quote]
        attribute(:quote, Quote)

        # @return [String] Identifier of a shipment. A shipment contains the boxes and units being inbounded.
        attribute(:shipment_id, String, from: "shipmentId")

        # @return [String] Mode of shipment transportation that this option will provide.
        #
        # Possible values: `GROUND_SMALL_PARCEL`, `FREIGHT_LTL`, `FREIGHT_FTL_PALLET`, `FREIGHT_FTL_NONPALLET`,
        # `OCEAN_LCL`, `OCEAN_FCL`, `AIR_SMALL_PARCEL`, `AIR_SMALL_PARCEL_EXPRESS`.
        attribute(:shipping_mode, String, from: "shippingMode")

        # @return [String] Shipping program for the option. Possible values: `AMAZON_PARTNERED_CARRIER`,
        # `USE_YOUR_OWN_CARRIER`.
        attribute(:shipping_solution, String, from: "shippingSolution")

        # @return [String] Identifier of a transportation option. A transportation option represent one option for how
        # to send a shipment.
        attribute(:transportation_option_id, String, from: "transportationOptionId")
      end
    end
  end
end
