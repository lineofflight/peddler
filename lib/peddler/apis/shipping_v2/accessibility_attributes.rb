# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Defines the accessibility details of the access point.
      AccessibilityAttributes = Structure.new do
        # The approximate distance of access point from input postalCode's centroid.
        attribute?(:distance, String)

        # The approximate (static) drive time from input postal code's centroid.
        attribute?(:drive_time, Integer, from: "driveTime")
      end
    end
  end
end
