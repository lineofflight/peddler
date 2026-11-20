# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Information about a rejected shipping service.
      RejectedShippingService = Structure.new do
        # The rejected shipping carrier name. For example, USPS.
        attribute(:carrier_name, String, null: false, from: "CarrierName")

        # A reason code meant to be consumed programmatically. For example, `CARRIER_CANNOT_SHIP_TO_POBOX`.
        attribute(:rejection_reason_code, String, null: false, from: "RejectionReasonCode")

        # The rejected shipping service identifier. For example, `FEDEX_PTP_STANDARD_OVERNIGHT`.
        attribute(:shipping_service_id, String, null: false, from: "ShippingServiceId")

        # The rejected shipping service localized name. For example, FedEx Standard Overnight.
        attribute(:shipping_service_name, String, null: false, from: "ShippingServiceName")

        # A localized, human-readable description of the rejected reason.
        attribute?(:rejection_reason_message, String, from: "RejectionReasonMessage")
      end
    end
  end
end
