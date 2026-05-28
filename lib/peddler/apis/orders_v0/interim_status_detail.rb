# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class OrdersV0
      # Interim status information provided during the verification process to share granular progress updates while an
      # order is pending verification (for example, vet contacted through email).
      InterimStatusDetail = Structure.new do
        # @return [String] The identifier for the interim status type. Must be one of the `ValidInterimStatusCodes`
        #   values returned by the `getOrderRegulatedInfo` operation.
        attribute(:status_code, String, null: false, from: "statusCode")

        # @return [Time] The date and time when this interim status was set, in [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date and time format.
        attribute(:status_date_time, Time, null: false, from: "statusDateTime")
      end
    end
  end
end
