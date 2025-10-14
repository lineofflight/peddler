# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # A list of value-added services available for a shipping service offering.
      class AvailableValueAddedServiceGroupList < Array
        class << self
          def parse(array)
            new(array.map { |item| AvailableValueAddedServiceGroup.parse(item) })
          end
        end
      end
    end
  end
end
