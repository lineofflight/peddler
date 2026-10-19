# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module EasyShip20220323
      # The dimensions of the scheduled package.
      Dimensions = Structure.new do
        # The height dimension.
        attribute?(:height, Float)

        # Identifier for custom package dimensions.
        attribute?(:identifier, String)

        # The length dimension.
        attribute?(:length, Float)

        # Known values: `cm`.
        attribute?(:unit, String)

        # The width dimension.
        attribute?(:width, Float)
      end
    end
  end
end
