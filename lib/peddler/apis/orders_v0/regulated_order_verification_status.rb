# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # The verification status of the order, along with associated approval or rejection metadata.
      RegulatedOrderVerificationStatus = Structure.new do
        # When true, the regulated information provided in the order requires a review by the merchant.
        attribute(:requires_merchant_action, :boolean, null: false, from: "RequiresMerchantAction")

        # The verification status of the order.
        attribute(:status, String, null: false, from: "Status")

        # A list of valid rejection reasons that may be used to reject the order's regulated information.
        attribute(:valid_rejection_reasons, [RejectionReason], null: false, from: "ValidRejectionReasons")

        # The identifier for the order's regulated information reviewer.
        attribute?(:external_reviewer_id, String, from: "ExternalReviewerId")

        # The reason for rejecting the order's regulated information. Not present if the order isn't rejected.
        attribute?(:rejection_reason, RejectionReason, from: "RejectionReason")

        # The date the order was reviewed. In [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date
        # time format.
        attribute?(:review_date, String, from: "ReviewDate")

        # Valid interim status codes that may be used when populating `InterimStatusDetail`. Each element contains a
        # `StatusCode` identifier and its customer-facing `StatusDescription`.
        attribute?(:valid_interim_status_codes, [ValidInterimStatusCode], from: "ValidInterimStatusCodes")

        # A list of valid verification details that may be provided and the criteria required for when the verification
        # detail can be provided.
        attribute?(:valid_verification_details, [ValidVerificationDetail], from: "ValidVerificationDetails")
      end
    end
  end
end
