# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The size dimensions of the label.
      DocumentSize = Structure.new do
        # @return [Float] The width of the document measured in the units specified.
        attribute(:width, Float)

        # @return [Float] The length of the document measured in the units specified.
        attribute(:length, Float)

        # @return [String] The unit of measurement.
        attribute(:unit, String)
      end
    end
  end
end
