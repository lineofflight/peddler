# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/vendor_shipments_v1/stop"

module Peddler
  module Types
    module VendorShipmentsV1
      # This is used only for direct import shipment confirmations.
      Route = Structure.new do
        # @return [Array<Stop>] The port or location involved in transporting the cargo, as specified in transportation
        # contracts or operational plans.
        attribute(:stops, [Stop])
      end
    end
  end
end
