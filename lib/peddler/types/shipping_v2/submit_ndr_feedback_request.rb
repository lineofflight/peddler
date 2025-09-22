# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/shipping_v2/ndr_request_data"

module Peddler
  module Types
    module ShippingV2
      # The request schema for the NdrFeedback operation
      SubmitNdrFeedbackRequest = Structure.new do
        # @return [String]
        attribute(:tracking_id, String, from: "trackingId")

        # @return [String]
        attribute(:ndr_action, String, from: "ndrAction")

        # @return [NdrRequestData]
        attribute(:ndr_request_data, NdrRequestData, from: "ndrRequestData")
      end
    end
  end
end
