# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/vendor_shipments_v1/error"
require "peddler/types/vendor_shipments_v1/transportation_labels"

module Peddler
  module Types
    module VendorShipmentsV1
      # The response schema for the GetShipmentLabels operation.
      GetShipmentLabels = Structure.new do
        # @return [Array<Error>]
        attribute?(:errors, [Error])

        # @return [TransportationLabels]
        attribute?(:payload, TransportationLabels)
      end
    end
  end
end
