# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Object representing a benefit that is excluded for a shipping offer or rate.
      ExcludedBenefit = Structure.new do
        # benefit
        attribute(:benefit, String, null: false)

        attribute?(:reason_codes, [String], from: "reasonCodes")
      end
    end
  end
end
