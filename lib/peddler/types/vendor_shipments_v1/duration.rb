# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorShipmentsV1
      # Duration after manufacturing date during which the product is valid for consumption.
      Duration = Structure.new do
        # @return [String] Unit for duration.
        attribute(:duration_unit, String, from: "durationUnit")

        # @return [Integer] Value for the duration in terms of the durationUnit.
        attribute(:duration_value, Integer, from: "durationValue")
      end
    end
  end
end
