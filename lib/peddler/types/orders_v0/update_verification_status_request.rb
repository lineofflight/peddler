# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/update_verification_status_request_body"

module Peddler
  module Types
    module OrdersV0
      # The request body for the `updateVerificationStatus` operation.
      UpdateVerificationStatusRequest = Structure.new do
        # @return [UpdateVerificationStatusRequestBody] The updated values of the `VerificationStatus` field.
        attribute(:regulated_order_verification_status, UpdateVerificationStatusRequestBody, from: "regulatedOrderVerificationStatus")
      end
    end
  end
end
