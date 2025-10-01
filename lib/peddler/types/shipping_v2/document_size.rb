# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The size dimensions of the label.
      DocumentSize = Structure.new do
        # @return [Float] The length of the document measured in the units specified.
        attribute(:length, Float)

        # @return [String] The unit of measurement.
        attribute(:unit, String)

        # @return [Float] The width of the document measured in the units specified.
        attribute(:width, Float)
      end
    end
  end
end
