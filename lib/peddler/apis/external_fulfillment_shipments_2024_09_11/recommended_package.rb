# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Recommendations for a package
      RecommendedPackage = Structure.new do
        attribute(:dimensions, PackageDimensions, null: false)

        attribute(:line_items, [RecommendedPackageLineItem], null: false, from: "lineItems")

        attribute(:weight, Weight, null: false)
      end
    end
  end
end
