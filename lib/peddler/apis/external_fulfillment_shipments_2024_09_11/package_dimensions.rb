# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # The dimensions of a package.
      PackageDimensions = Structure.new do
        # The height of the package.
        attribute(:height, Dimension, null: false)

        # The length of the package.
        attribute(:length, Dimension, null: false)

        # The width of the package.
        attribute(:width, Dimension, null: false)
      end
    end
  end
end
