# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # Measurement of a package's dimensions.
      Dimensions = Structure.new do
        # The height of a package.
        attribute(:height, Float, null: false)

        # The length of a package.
        attribute(:length, Float, null: false)

        attribute(:unit_of_measurement, String, null: false, from: "unitOfMeasurement")

        # The width of a package.
        attribute(:width, Float, null: false)
      end
    end
  end
end
