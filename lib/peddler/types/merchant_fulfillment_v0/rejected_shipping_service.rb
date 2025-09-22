# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Information about a rejected shipping service
      RejectedShippingService = Structure.new do
        # @return [String] The rejected shipping carrier name. For example, USPS.
        attribute(:carrier_name, String, from: "CarrierName")

        # @return [String] The rejected shipping service localized name. For example, FedEx Standard Overnight.
        attribute(:shipping_service_name, String, from: "ShippingServiceName")

        # @return [String] The rejected shipping service identifier. For example, `FEDEX_PTP_STANDARD_OVERNIGHT`.
        attribute(:shipping_service_id, String, from: "ShippingServiceId")

        # @return [String] A reason code meant to be consumed programatically. For example,
        # `CARRIER_CANNOT_SHIP_TO_POBOX`.
        attribute(:rejection_reason_code, String, from: "RejectionReasonCode")

        # @return [String] A localized human readable description of the rejected reason.
        attribute(:rejection_reason_message, String, from: "RejectionReasonMessage")
      end
    end
  end
end
