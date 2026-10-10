# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # The dimensions of a package contained in a shipment.
      PackageDimensions = Structure.new do
        # The height dimension. If you don't specify `PredefinedPackageDimensions`, you must specify the height.
        attribute?(:height, Float, from: "Height")

        # The length dimension. If you don't specify `PredefinedPackageDimensions`, you must specify the length.
        attribute?(:length, Float, from: "Length")

        attribute?(:predefined_package_dimensions, String, from: "PredefinedPackageDimensions")

        # The unit of measurement. If you don't specify `PredefinedPackageDimensions`, you must specify the unit.
        attribute?(:unit, String, from: "Unit")

        # The width dimension. If you don't specify `PredefinedPackageDimensions`, you must specify the width.
        attribute?(:width, Float, from: "Width")
      end
    end
  end
end
