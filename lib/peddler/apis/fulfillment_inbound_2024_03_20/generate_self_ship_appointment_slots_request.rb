# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `generateSelfShipAppointmentSlots` request.
      GenerateSelfShipAppointmentSlotsRequest = Structure.new do
        # The desired end date. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format.
        attribute?(:desired_end_date, Time, from: "desiredEndDate")

        # The desired start date. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format.
        attribute?(:desired_start_date, Time, from: "desiredStartDate")
      end
    end
  end
end
