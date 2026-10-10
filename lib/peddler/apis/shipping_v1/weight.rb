# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV1
      # The weight.
      Weight = Structure.new do
        # The unit of measurement.
        attribute(:unit, String, null: false)

        # The measurement value.
        attribute(:value, Float, null: false)
      end
    end
  end
end
