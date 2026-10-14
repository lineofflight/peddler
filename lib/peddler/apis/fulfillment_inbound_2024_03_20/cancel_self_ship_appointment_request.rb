# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `cancelSelfShipAppointment` request.
      CancelSelfShipAppointmentRequest = Structure.new do
        # @return [String] Known values: `APPOINTMENT_REQUESTED_BY_MISTAKE`, `VEHICLE_DELAY`, `SLOT_NOT_SUITABLE`,
        #   `OUTSIDE_CARRIER_BUSINESS_HOURS`, `UNFAVOURABLE_EXTERNAL_CONDITIONS`, `PROCUREMENT_DELAY`,
        #   `SHIPPING_PLAN_CHANGED`, `INCREASED_QUANTITY`, `OTHER`.
        attribute?(:reason_comment, String, from: "reasonComment")
      end
    end
  end
end
