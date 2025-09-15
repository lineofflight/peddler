# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Denotes time of the day, used for defining opening or closing time of access points
      TimeOfDay = Structure.new do
        # @return [Integer] Denotes hour of the day, used for defining opening or closing time of access points
        attribute(:hour_of_day, Integer, from: "hourOfDay")

        # @return [Integer] Denotes minute of the hour, used for defining opening or closing time of access points
        attribute(:minute_of_hour, Integer, from: "minuteOfHour")

        # @return [Integer] Denotes second of the minute, used for defining opening or closing time of access points
        attribute(:second_of_minute, Integer, from: "secondOfMinute")
      end
    end
  end
end
