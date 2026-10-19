# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Duration after manufacturing date during which the product is valid for consumption.
      Duration = Structure.new do
        # Unit for duration. Known values: `Days`, `Months`.
        attribute(:duration_unit, String, null: false, from: "durationUnit")

        # Value for the duration in terms of the durationUnit.
        attribute(:duration_value, Integer, null: false, from: "durationValue")
      end
    end
  end
end
