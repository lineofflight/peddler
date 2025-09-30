# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/date_range"
require "peddler/types/shipping_v2/operating_hours"

module Peddler
  module Types
    module ShippingV2
      # Defines exceptions to standard operating hours for certain date ranges.
      ExceptionOperatingHours = Structure.new do
        # @return [DateRange]
        attribute?(:date_range, DateRange, from: "dateRange")

        # @return [OperatingHours]
        attribute?(:operating_hours, OperatingHours, from: "operatingHours")
      end
    end
  end
end
