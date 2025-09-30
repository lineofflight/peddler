# frozen_string_literal: true

require "peddler/types/shipping_v2/access_point"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ShippingV2
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
