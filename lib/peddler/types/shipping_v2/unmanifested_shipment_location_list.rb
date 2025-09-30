# frozen_string_literal: true

require "peddler/types/shipping_v2/unmanifested_shipment_location"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of UnmanifestedShipmentLocation
      class UnmanifestedShipmentLocationList < Array
        class << self
          def parse(array)
            new(array.map { |item| UnmanifestedShipmentLocation.parse(item) })
          end
        end
      end
    end
  end
end
