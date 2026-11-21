# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Recommendations for a package
      RecommendedPackage = Structure.new do
        attribute(:dimensions, PackageDimensions, null: false)

        attribute(:weight, Weight, null: false)

        attribute?(:line_items, [RecommendedPackageLineItem], from: "lineItems")
      end
    end
  end
end
