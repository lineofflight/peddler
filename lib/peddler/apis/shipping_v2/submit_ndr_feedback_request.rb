# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # The request schema for the NdrFeedback operation
      SubmitNdrFeedbackRequest = Structure.new do
        # Known values: `RESCHEDULE`, `REATTEMPT`, `RTO`.
        attribute(:ndr_action, String, null: false, from: "ndrAction")

        attribute(:tracking_id, String, null: false, from: "trackingId")

        attribute?(:ndr_request_data, NdrRequestData, from: "ndrRequestData")
      end
    end
  end
end
