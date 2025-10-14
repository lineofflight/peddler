# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # The request body for the `updateVerificationStatus` operation.
      UpdateVerificationStatusRequest = Structure.new do
        # @return [UpdateVerificationStatusRequestBody] The updated values of the `VerificationStatus` field.
        attribute(:regulated_order_verification_status, UpdateVerificationStatusRequestBody, from: "regulatedOrderVerificationStatus")
      end
    end
  end
end
