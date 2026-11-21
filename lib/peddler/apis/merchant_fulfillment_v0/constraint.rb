# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # A validation constraint.
      Constraint = Structure.new do
        # A validation string.
        attribute(:validation_string, String, null: false, from: "ValidationString")

        # A regular expression.
        attribute?(:validation_reg_ex, String, from: "ValidationRegEx")
      end
    end
  end
end
