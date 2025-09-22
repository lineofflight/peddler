# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Defines the accessibility details of the access point.
      AccessibilityAttributes = Structure.new do
        # @return [String] The approximate distance of access point from input postalCode's centroid.
        attribute(:distance, String)

        # @return [Integer] The approximate (static) drive time from input postal code's centroid.
        attribute(:drive_time, Integer, from: "driveTime")
      end
    end
  end
end
