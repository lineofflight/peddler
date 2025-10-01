# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/dimension"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
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
