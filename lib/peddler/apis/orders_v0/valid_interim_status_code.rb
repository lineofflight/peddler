# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # A valid interim status code and its customer-facing description. Available with the `getOrderRegulatedInfo`
      # operation to indicate which status codes can populate the `InterimStatusDetail` field.
      ValidInterimStatusCode = Structure.new do
        # @return [String] The identifier for the interim status type.
        attribute(:status_code, String, null: false, from: "StatusCode")

        # @return [String] A customer-facing description of the interim status.
        attribute(:status_description, String, null: false, from: "StatusDescription")
      end
    end
  end
end
