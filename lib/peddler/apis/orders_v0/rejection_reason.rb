# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The reason for rejecting the order's regulated information. This is only present if the order is rejected.
      RejectionReason = Structure.new do
        # The description of this rejection reason.
        attribute(:rejection_reason_description, String, null: false, from: "RejectionReasonDescription")

        # The unique identifier for the rejection reason.
        attribute(:rejection_reason_id, String, null: false, from: "RejectionReasonId")
      end
    end
  end
end
