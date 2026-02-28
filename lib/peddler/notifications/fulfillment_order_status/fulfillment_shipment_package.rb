# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      FulfillmentShipmentPackage = Structure.new do
        # @return [String]
        attribute(:carrier_code, String, null: false, from: "CarrierCode")

        # @return [Integer]
        attribute(:package_number, Integer, null: false, from: "PackageNumber")

        # @return [String]
        attribute(:tracking_number, String, null: false, from: "TrackingNumber")
      end
    end
  end
end
