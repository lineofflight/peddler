# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/external_fulfillment_shipments_2024_09_11/recommended_package"
require "peddler/types/external_fulfillment_shipments_2024_09_11/address"

module Peddler
  module Types
    module ExternalFulfillmentShipments20240911
      # Shipping information for the packages in a shipment.
      ShippingInfo = Structure.new do
        # @return [String] The date and time when Amazon expects the seller to ship the packages.
        attribute(:expected_shipping_date_time_in_utc, String, from: "expectedShippingDateTimeInUTC")

        # @return [Array<RecommendedPackage>]
        attribute?(:recommended_packages, [RecommendedPackage], from: "recommendedPackages")

        # @return [String] The ship method recommended by the Amazon Fulfillment Network for the packages in this
        # shipment.
        attribute?(:recommended_ship_method, String, from: "recommendedShipMethod")

        # @return [Address] The address to which the packages must be shipped. Provide only basic information about the
        # buyer's address needed for taxation purposes.
        attribute?(:ship_to_address, Address, from: "shipToAddress")

        # @return [String] The type of shipping that the seller uses to deliver a customer order.
        attribute?(:shipping_type, String, from: "shippingType")
      end
    end
  end
end
