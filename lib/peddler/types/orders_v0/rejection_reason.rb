# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module OrdersV0
      # The reason for rejecting the order's regulated information. This is only present if the order is rejected.
      RejectionReason = Structure.new do
        # @return [String] The unique identifier for the rejection reason.
        attribute(:rejection_reason_id, String, from: "RejectionReasonId")

        # @return [String] The description of this rejection reason.
        attribute(:rejection_reason_description, String, from: "RejectionReasonDescription")
      end
    end
  end
end
