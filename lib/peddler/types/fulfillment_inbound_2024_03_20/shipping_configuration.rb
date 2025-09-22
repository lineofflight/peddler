# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The shipping configurations supported for the packing option. Available modes are ground small parcel, freight
      # less-than-truckload (LTL), freight full-truckload (FTL) palletized, freight FTL non-palletized, ocean
      # less-than-container-load (LCL), ocean full-container load (FCL), air small parcel, and air small parcel express.
      ShippingConfiguration = Structure.new do
        # @return [String] Mode of shipment transportation that this option will provide.
        #
        # Possible values: `GROUND_SMALL_PARCEL`, `FREIGHT_LTL`, `FREIGHT_FTL_PALLET`, `FREIGHT_FTL_NONPALLET`,
        # `OCEAN_LCL`, `OCEAN_FCL`, `AIR_SMALL_PARCEL`, `AIR_SMALL_PARCEL_EXPRESS`.
        attribute(:shipping_mode, String, from: "shippingMode")

        # @return [String] Shipping program for the option. Possible values: `AMAZON_PARTNERED_CARRIER`,
        # `USE_YOUR_OWN_CARRIER`.
        attribute(:shipping_solution, String, from: "shippingSolution")
      end
    end
  end
end
