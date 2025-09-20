# frozen_string_literal: true

require "peddler/types/shipping_v2/available_value_added_service_group"

module Peddler
  module Types
    module ShippingV2
      # A list of value-added services available for a shipping service offering.
      class AvailableValueAddedServiceGroupList < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AvailableValueAddedServiceGroup.parse(item) })
          end
        end
      end
    end
  end
end
