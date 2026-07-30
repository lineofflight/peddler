# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20260704
      # A constraint that may affect a fulfillment order.
      Constraint = Structure.new do
        # @return [String] The constraint code.
        attribute(:code, String, null: false)

        # @return [String] A human-readable description of the constraint.
        attribute(:message, String, null: false)

        # @return [String] The type of constraint.
        attribute(:type, String, null: false)

        # @return [Array<ConstraintDetail>] Array of constraint details
        attribute?(:details, [ConstraintDetail])
      end
    end
  end
end
