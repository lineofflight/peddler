# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # An order attribute with its original value and the pre-approved alternative value suggested by the vet.
      ApprovedAttribute = Structure.new do
        # @return [String] The pre-approved value that would result in order approval.
        attribute(:approved_value, String, null: false, from: "approvedValue")

        # @return [String] The name of the attribute requiring correction (for example, `asin`, `petWeight`).
        attribute(:attribute_name, String, null: false, from: "attributeName")

        # @return [String] The original value of the attribute in the rejected order.
        attribute(:original_value, String, null: false, from: "originalValue")
      end
    end
  end
end
