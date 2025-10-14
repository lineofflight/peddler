# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class EasyShip20220323
      # The dimensions of the scheduled package.
      Dimensions = Structure.new do
        # @return [Float] The height dimension.
        attribute?(:height, Float)

        # @return [String] Identifier for custom package dimensions.
        attribute?(:identifier, String)

        # @return [Float] The length dimension.
        attribute?(:length, Float)

        # @return [String]
        attribute?(:unit, String)

        # @return [Float] The width dimension.
        attribute?(:width, Float)
      end
    end
  end
end
