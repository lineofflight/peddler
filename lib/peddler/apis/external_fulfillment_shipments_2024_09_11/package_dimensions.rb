# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # The dimensions of a package.
      PackageDimensions = Structure.new do
        # @return [Dimension] The height of the package.
        attribute(:height, Dimension)

        # @return [Dimension] The length of the package.
        attribute(:length, Dimension)

        # @return [Dimension] The width of the package.
        attribute(:width, Dimension)
      end
    end
  end
end
