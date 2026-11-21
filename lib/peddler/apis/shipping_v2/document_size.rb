# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The size dimensions of the label.
      DocumentSize = Structure.new do
        # The length of the document measured in the units specified.
        attribute(:length, Float, null: false)

        # The unit of measurement. Known values: `INCH`, `CENTIMETER`.
        attribute(:unit, String, null: false)

        # The width of the document measured in the units specified.
        attribute(:width, Float, null: false)
      end
    end
  end
end
