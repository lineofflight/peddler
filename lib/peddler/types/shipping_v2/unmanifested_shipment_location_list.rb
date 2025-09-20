# frozen_string_literal: true

require "peddler/types/shipping_v2/unmanifested_shipment_location"

module Peddler
  module Types
    module ShippingV2
      # A list of UnmanifestedShipmentLocation
      class UnmanifestedShipmentLocationList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| UnmanifestedShipmentLocation.parse(item) })
          end
        end
      end
    end
  end
end
