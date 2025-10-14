# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `generateSelfShipAppointmentSlots` request.
      GenerateSelfShipAppointmentSlotsRequest = Structure.new do
        # @return [Time] The desired end date. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
        # datetime format.
        attribute?(:desired_end_date, Time, from: "desiredEndDate")

        # @return [Time] The desired start date. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601)
        # datetime format.
        attribute?(:desired_start_date, Time, from: "desiredStartDate")
      end
    end
  end
end
