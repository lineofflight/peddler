# frozen_string_literal: true

require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/address"
require "peddler/types/vendor_direct_fulfillment_shipping_2021_12_28/shipment_schedule"

module Peddler
  module Types
    module VendorDirectFulfillmentShipping20211228
      # Details for the shipment status update given by the vendor for the specific package.
      StatusUpdateDetails = Structure.new do
        # @return [String] The shipment tracking number is required for every package and should match the
        # `trackingNumber` sent for the shipment confirmation.
        attribute(:tracking_number, String, from: "trackingNumber")

        # @return [String] Indicates the shipment status code of the package that provides transportation information
        # for Amazon tracking systems and ultimately for the final customer. For more information, refer to the
        # [Additional Fields
        # Explanation](https://developer-docs.amazon.com/sp-api/docs/vendor-direct-fulfillment-shipping-api-use-case-guide#additional-fields-explanation).
        attribute(:status_code, String, from: "statusCode")

        # @return [String] Provides a reason code for the status of the package that will provide additional information
        # about the transportation status. For more information, refer to the [Additional Fields
        # Explanation](https://developer-docs.amazon.com/sp-api/docs/vendor-direct-fulfillment-shipping-api-use-case-guide#additional-fields-explanation).
        attribute(:reason_code, String, from: "reasonCode")

        # @return [String] The date and time when the shipment status was updated. Values are in [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date-time format, with UTC time zone or UTC
        # offset. For example, 2020-07-16T23:00:00Z or 2020-07-16T23:00:00+01:00.
        attribute(:status_date_time, String, from: "statusDateTime")

        # @return [Address]
        attribute(:status_location_address, Address, from: "statusLocationAddress")

        # @return [ShipmentSchedule]
        attribute(:shipment_schedule, ShipmentSchedule, from: "shipmentSchedule")
      end
    end
  end
end
