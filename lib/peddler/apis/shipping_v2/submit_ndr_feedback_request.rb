# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # The request schema for the NdrFeedback operation
      SubmitNdrFeedbackRequest = Structure.new do
        # @return [String]
        attribute(:ndr_action, String, from: "ndrAction")

        # @return [String]
        attribute(:tracking_id, String, from: "trackingId")

        # @return [NdrRequestData]
        attribute?(:ndr_request_data, NdrRequestData, from: "ndrRequestData")
      end
    end
  end
end
