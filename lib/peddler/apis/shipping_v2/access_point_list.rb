# frozen_string_literal: true

# This file is generated. Edit template if necessary.

module Peddler
  module APIs
    class ShippingV2
      # List of relevant Access points requested by shipper. These access points are sorted by proximity to postal code,
      # and are limited to 40. We have internally defined a radius value to render relevant results.
      class AccessPointList < Array
        class << self
          def parse(array)
            new(array.map { |item| AccessPoint.parse(item) })
          end
        end
      end
    end
  end
end
