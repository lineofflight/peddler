# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `generateSelfShipAppointmentSlots` request.
      GenerateSelfShipAppointmentSlotsRequest = Structure.new do
        # @return [String] The desired end date. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
        # datetime format.
        attribute?(:desired_end_date, String, from: "desiredEndDate")

        # @return [String] The desired start date. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
        # datetime format.
        attribute?(:desired_start_date, String, from: "desiredStartDate")
      end
    end
  end
end
