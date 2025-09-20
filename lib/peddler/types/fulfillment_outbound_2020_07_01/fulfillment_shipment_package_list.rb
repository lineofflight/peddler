# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/fulfillment_shipment_package"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # An array of fulfillment shipment package information.
      class FulfillmentShipmentPackageList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| FulfillmentShipmentPackage.parse(item) })
          end
        end
      end
    end
  end
end
