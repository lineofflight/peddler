# frozen_string_literal: true

require "peddler/types/shipping_v2/one_click_shipment_value_added_service"

module Peddler
  module Types
    module ShippingV2
      # The value-added services to be added to a shipping service purchase.
      class OneClickShipmentValueAddedServiceDetails < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| OneClickShipmentValueAddedService.parse(item) })
          end
        end
      end
    end
  end
end
