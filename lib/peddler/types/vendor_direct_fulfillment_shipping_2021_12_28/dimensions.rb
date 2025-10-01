# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Physical dimensional measurements of a container.
      Dimensions = Structure.new do
        # @return [String] The height of the container.
        attribute(:height, String)

        # @return [String] The length of the container.
        attribute(:length, String)

        # @return [String] The unit of measure for dimensions.
        attribute(:unit_of_measure, String, from: "unitOfMeasure")

        # @return [String] The width of the container.
        attribute(:width, String)
      end
    end
  end
end
