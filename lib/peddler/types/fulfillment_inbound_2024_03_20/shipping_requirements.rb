# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The possible shipping modes for the packing option for a given shipping solution or program. Available solutions
      # are Amazon-Partnered Carrier and Use Your Own Carrier. Available modes are ground small parcel, freight
      # less-than-truckload (LTL), freight full-truckload (FTL) palletized, freight FTL non-palletized, ocean
      # less-than-container-load (LCL), ocean full-container load (FCL), air small parcel, and air small parcel express.
      ShippingRequirements = Structure.new do
        # @return [Array<String>] Available shipment modes for this shipping program.
        attribute(:modes, [String])

        # @return [String] Shipping program for the option. Can be: `AMAZON_PARTNERED_CARRIER`, `USE_YOUR_OWN_CARRIER`.
        attribute(:solution, String)
      end
    end
  end
end
