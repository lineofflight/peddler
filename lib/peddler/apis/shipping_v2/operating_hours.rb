# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module ShippingV2
      # The hours in which the access point shall remain operational
      OperatingHours = Structure.new do
        attribute?(:closing_time, TimeOfDay, from: "closingTime")

        # midDayClosures operating hours array
        attribute?(:mid_day_closures, [TimeOfDay], from: "midDayClosures")

        attribute?(:opening_time, TimeOfDay, from: "openingTime")
      end
    end
  end
end
