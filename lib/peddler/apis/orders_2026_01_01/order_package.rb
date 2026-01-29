# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class Orders20260101
      # Information about a physical shipping package, including tracking details. **Note:** Only available for
      # merchant-fulfilled (FBM) orders.
      OrderPackage = Structure.new do
        # @return [String] A unique identifier for this package within the context of the order.
        attribute(:package_reference_id, String, from: "packageReferenceId")

        # @return [String] The carrier responsible for transporting this package to the customer.
        attribute?(:carrier, String)

        # @return [Time] The exact time when this shipping package was created and prepared for shipment. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:created_time, Time, from: "createdTime")

        # @return [Array<PackageItem>] A list of all order items included in this specific package.
        attribute?(:package_items, [PackageItem], from: "packageItems")

        # @return [PackageStatus] The current status of this package.
        attribute?(:package_status, PackageStatus, from: "packageStatus")

        # @return [MerchantAddress] The physical address from which this package was shipped, typically the merchant's
        #   warehouse or fulfillment center.
        attribute?(:ship_from_address, MerchantAddress, from: "shipFromAddress")

        # @return [Time] The exact time when this package was handed over to the carrier and began its journey to the
        #   customer. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) format.
        attribute?(:ship_time, Time, from: "shipTime")

        # @return [String] The specific shipping method or service used for delivering this package.
        attribute?(:shipping_service, String, from: "shippingService")

        # @return [String] The carrier-provided tracking number that customers can use to monitor the package's delivery
        #   progress.
        attribute?(:tracking_number, String, from: "trackingNumber")
      end
    end
  end
end
