# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/package_dimensions"
require "peddler/types/external_fulfillment_shipments_2024_09_11/package_line_item"
require "peddler/types/external_fulfillment_shipments_2024_09_11/weight"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # A package that is created to ship one or more of a shipment's line items.
      Package = Structure.new do
        # @return [PackageDimensions] The dimensions of the package.
        attribute(:dimensions, PackageDimensions)

        # @return [String] An ID that uniquely identifies a package within a shipment.
        attribute(:id, String)

        # @return [Array<PackageLineItem>] The list of line items in a package.
        attribute(:package_line_items, [PackageLineItem], from: "packageLineItems")

        # @return [Weight] The weight of the package. The package must weigh at least 5 grams.
        attribute(:weight, Weight)

        # @return [Array<String>] The optional list of HAZMAT labels applied to the package.
        attribute?(:hazmat_labels, [String], from: "hazmatLabels")

        # @return [String] Whether the package requires standard handling or extra care.
        attribute?(:package_handling_requirements, String, from: "packageHandlingRequirements")

        # @return [String] The current status of the package.
        attribute?(:status, String)
      end
    end
  end
end
