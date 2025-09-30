# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A validation constraint.
      Constraint = Structure.new do
        # @return [String] A regular expression.
        attribute?(:validation_reg_ex, String, from: "ValidationRegEx")

        # @return [String] A validation string.
        attribute(:validation_string, String, from: "ValidationString")
      end
    end
  end
end
