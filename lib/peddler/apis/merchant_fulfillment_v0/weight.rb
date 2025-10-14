# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The weight.
      Weight = Structure.new do
        # @return [String]
        attribute(:unit, String, from: "Unit")

        # @return [Float]
        attribute(:value, Float, from: "Value")
      end
    end
  end
end
