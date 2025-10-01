# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/package_dimensions"
require "peddler/types/external_fulfillment_shipments_2024_09_11/recommended_package_line_item"
require "peddler/types/external_fulfillment_shipments_2024_09_11/weight"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
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
