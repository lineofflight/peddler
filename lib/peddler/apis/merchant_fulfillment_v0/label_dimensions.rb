# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Dimensions for printing a shipping label.
      LabelDimensions = Structure.new do
        # The length dimension.
        attribute(:length, Float, null: false, from: "Length")

        # The unit of measurement.
        attribute(:unit, String, null: false, from: "Unit")

        # The width dimension.
        attribute(:width, Float, null: false, from: "Width")
      end
    end
  end
end
