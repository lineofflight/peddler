# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/verification_details"

module Peddler
  module Types
    module OrdersV0
      # The updated values of the `VerificationStatus` field.
      UpdateVerificationStatusRequestBody = Structure.new do
        # @return [String] The identifier of the order's regulated information reviewer.
        attribute(:external_reviewer_id, String, from: "externalReviewerId")

        # @return [String] The unique identifier of the rejection reason used for rejecting the order's regulated
        # information. Only required if the new status is rejected.
        attribute?(:rejection_reason_id, String, from: "rejectionReasonId")

        # @return [String] The new verification status of the order.
        attribute?(:status, String)

        # @return [VerificationDetails] Additional information regarding the verification of the order.
        attribute?(:verification_details, VerificationDetails, from: "verificationDetails")
      end
    end
  end
end
