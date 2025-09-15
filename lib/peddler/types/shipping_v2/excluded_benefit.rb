# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Object representing a benefit that is excluded for a shipping offer or rate.
      ExcludedBenefit = Structure.new do
        # @return [String] benefit
        attribute(:benefit, String)

        # @return [Array]
        attribute(:reason_codes, Array, from: "reasonCodes")
      end
    end
  end
end
