# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # Additional information about a constraint violation, providing the specific type of detail and its corresponding
      # value that caused the violation.
      ConstraintDetail = Structure.new do
        # @return [String] The type of the constraint detail.
        attribute(:type, String, null: false)

        # @return [String] The value of the constraint detail.
        attribute(:value, String, null: false)
      end
    end
  end
end
