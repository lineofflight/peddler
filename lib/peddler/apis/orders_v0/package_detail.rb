# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class OrdersV0
      # Properties of packages
      PackageDetail = Structure.new do
        # @return [String] Identifies the carrier that will deliver the package. This field is required for all
        #   marketplaces. For more information, refer to the [`CarrierCode`
        #   announcement](https://developer-docs.amazon.com/sp-api/changelog/carriercode-value-required-in-shipment-confirmations-for-br-mx-ca-sg-au-in-jp-marketplaces).
        attribute(:carrier_code, String, from: "carrierCode")

        # @return [Array<ConfirmShipmentOrderItem>] The list of order items and quantities to be updated.
        attribute(:order_items, [ConfirmShipmentOrderItem], from: "orderItems")

        # @return [String]
        attribute(:package_reference_id, String, from: "packageReferenceId")

        # @return [Time] The shipping date for the package. Must be in
        #   {https://developer-docs.amazon.com/sp-api/docs/iso-8601 ISO 8601} date/time format.
        attribute(:ship_date, Time, from: "shipDate")

        # @return [String] The tracking number used to obtain tracking and delivery information.
        attribute(:tracking_number, String, from: "trackingNumber")

        # @return [String] Carrier name that will deliver the package. Required when `carrierCode` is "Other"
        attribute?(:carrier_name, String, from: "carrierName")

        # @return [String] The unique identifier for the supply source.
        attribute?(:ship_from_supply_source_id, String, from: "shipFromSupplySourceId")

        # @return [String] Ship method to be used for shipping the order.
        attribute?(:shipping_method, String, from: "shippingMethod")
      end
    end
  end
end
