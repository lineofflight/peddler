# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # Defines exceptions to standard operating hours for certain date ranges.
      ExceptionOperatingHours = Structure.new do
        attribute?(:date_range, DateRange, from: "dateRange")

        attribute?(:operating_hours, OperatingHours, from: "operatingHours")
      end
    end
  end
end
