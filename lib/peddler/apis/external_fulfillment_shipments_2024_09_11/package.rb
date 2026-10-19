# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # A package that is created to ship one or more of a shipment's line items.
      Package = Structure.new do
        # The dimensions of the package.
        attribute(:dimensions, PackageDimensions, null: false)

        # An ID that uniquely identifies a package within a shipment.
        attribute(:id, String, null: false)

        # The list of line items in a package.
        attribute(:package_line_items, [PackageLineItem], null: false, from: "packageLineItems")

        # The weight of the package. The package must weigh at least 5 grams.
        attribute(:weight, Weight, null: false)

        # The optional list of HAZMAT labels applied to the package.
        attribute?(:hazmat_labels, [String], from: "hazmatLabels")

        # Whether the package requires standard handling or extra care. Known values: `NORMAL`, `FRAGILE`.
        attribute?(:package_handling_requirements, String, from: "packageHandlingRequirements")

        # The current status of the package. Known values: `CREATED`, `PICKUP_SLOT_RETRIEVED`, `INVOICE_GENERATED`,
        # `SHIPLABEL_GENERATED`, `SHIPPED`, `DELIVERED`, `CANCELLED`.
        attribute?(:status, String)
      end
    end
  end
end
