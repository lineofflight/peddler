# frozen_string_literal: true

require "peddler/types/shipping_v2/available_value_added_service_group"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
      # A list of value-added services available for a shipping service offering.
      class AvailableValueAddedServiceGroupList < Array
        class << self
          def parse(array)
            array.is_a?(Array) ? new(array.map { |item| AvailableValueAddedServiceGroup.parse(item) }) : new
          end
        end
      end
    end
  end
end
