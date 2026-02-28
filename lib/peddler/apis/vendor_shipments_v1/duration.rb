# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorShipmentsV1
      # Duration after manufacturing date during which the product is valid for consumption.
      Duration = Structure.new do
        # @return [String] Unit for duration.
        attribute(:duration_unit, String, null: false, from: "durationUnit")

        # @return [Integer] Value for the duration in terms of the durationUnit.
        attribute(:duration_value, Integer, null: false, from: "durationValue")
      end
    end
  end
end
