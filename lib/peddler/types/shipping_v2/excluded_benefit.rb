# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Object representing a benefit that is excluded for a shipping offer or rate.
      ExcludedBenefit = Structure.new do
        # @return [String] benefit
        attribute(:benefit, String)

        # @return [Array<String>]
        attribute?(:reason_codes, [String], from: "reasonCodes")
      end
    end
  end
end
