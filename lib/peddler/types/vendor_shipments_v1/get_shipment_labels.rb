# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/transportation_labels"
require "peddler/types/vendor_shipments_v1/error"

module Peddler
  module Types
    module VendorShipmentsV1
      # The response schema for the GetShipmentLabels operation.
      GetShipmentLabels = Structure.new do
        # @return [TransportationLabels]
        attribute?(:payload, TransportationLabels)

        # @return [Array<Error>]
        attribute?(:errors, [Error])
      end
    end
  end
end
