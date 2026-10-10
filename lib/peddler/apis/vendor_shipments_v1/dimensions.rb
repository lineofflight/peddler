# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module VendorShipmentsV1
      # Physical dimensional measurements of a container.
      Dimensions = Structure.new do
        # The height of the container.
        attribute(:height, String, null: false)

        # The length of the container.
        attribute(:length, String, null: false)

        # The unit of measure for dimensions.
        attribute(:unit_of_measure, String, null: false, from: "unitOfMeasure")

        # The width of the container.
        attribute(:width, String, null: false)
      end
    end
  end
end
