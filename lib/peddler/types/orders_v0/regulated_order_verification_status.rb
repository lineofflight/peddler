# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/orders_v0/rejection_reason"
require "peddler/types/orders_v0/valid_verification_detail"

module Peddler
  module Types
    module OrdersV0
      # The verification status of the order, along with associated approval or rejection metadata.
      RegulatedOrderVerificationStatus = Structure.new do
        # @return [:boolean] When true, the regulated information provided in the order requires a review by the
        # merchant.
        attribute(:requires_merchant_action, :boolean, from: "RequiresMerchantAction")

        # @return [String] The verification status of the order.
        attribute(:status, String, from: "Status")

        # @return [Array<RejectionReason>] A list of valid rejection reasons that may be used to reject the order's
        # regulated information.
        attribute(:valid_rejection_reasons, [RejectionReason], from: "ValidRejectionReasons")

        # @return [String] The identifier for the order's regulated information reviewer.
        attribute?(:external_reviewer_id, String, from: "ExternalReviewerId")

        # @return [RejectionReason] The reason for rejecting the order's regulated information. Not present if the order
        # isn't rejected.
        attribute?(:rejection_reason, RejectionReason, from: "RejectionReason")

        # @return [String] The date the order was reviewed. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date time format.
        attribute?(:review_date, String, from: "ReviewDate")

        # @return [Array<ValidVerificationDetail>] A list of valid verification details that may be provided and the
        # criteria required for when the verification detail can be provided.
        attribute?(:valid_verification_details, [ValidVerificationDetail], from: "ValidVerificationDetails")
      end
    end
  end
end
