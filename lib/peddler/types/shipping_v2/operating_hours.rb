# frozen_string_literal: true

require "peddler/types/shipping_v2/time_of_day"

module Peddler
  module Types
    module ShippingV2
      # The hours in which the access point shall remain operational
      OperatingHours = Structure.new do
        # @return [TimeOfDay]
        attribute(:closing_time, TimeOfDay, from: "closingTime")

        # @return [TimeOfDay]
        attribute(:opening_time, TimeOfDay, from: "openingTime")

        # @return [Array<TimeOfDay>] midDayClosures operating hours array
        attribute(:mid_day_closures, [TimeOfDay], from: "midDayClosures")
      end
    end
  end
end
