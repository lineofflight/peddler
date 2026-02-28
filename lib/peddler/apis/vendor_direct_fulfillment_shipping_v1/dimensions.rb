# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class VendorDirectFulfillmentShippingV1
      # Physical dimensional measurements of a container.
      Dimensions = Structure.new do
        # @return [String] The height of the container.
        attribute(:height, String, null: false)

        # @return [String] The length of the container.
        attribute(:length, String, null: false)

        # @return [String] The unit of measure for dimensions.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")

        # @return [String] The width of the container.
        attribute(:width, String, null: false)
      end
    end
  end
end
