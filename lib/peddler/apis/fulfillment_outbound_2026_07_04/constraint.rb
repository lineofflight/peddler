# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20260704
      # A constraint that may affect a fulfillment order.
      Constraint = Structure.new do
        # The constraint code.
        attribute(:code, String, null: false)

        # A human-readable description of the constraint.
        attribute(:message, String, null: false)

        # The type of constraint.
        attribute(:type, String, null: false)

        # Array of constraint details
        attribute?(:details, [ConstraintDetail])
      end
    end
  end
end
