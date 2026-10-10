# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Specifies the unit of measure and quantity for items that are sold by weight, volume, length, or other
      # measurements rather than simple count.
      Measurement = Structure.new do
        # The specific unit of measurement used to quantify this item.
        attribute(:unit, String, null: false)

        # The numerical quantity or amount being measured in the specified unit.
        attribute(:value, Float, null: false)
      end
    end
  end
end
