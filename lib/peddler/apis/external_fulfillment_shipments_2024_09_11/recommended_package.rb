# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Recommendations for a package
      RecommendedPackage = Structure.new do
        # @return [PackageDimensions]
        attribute(:dimensions, PackageDimensions)

        # @return [Array<RecommendedPackageLineItem>]
        attribute(:line_items, [RecommendedPackageLineItem], from: "lineItems")

        # @return [Weight]
        attribute(:weight, Weight)
      end
    end
  end
end
