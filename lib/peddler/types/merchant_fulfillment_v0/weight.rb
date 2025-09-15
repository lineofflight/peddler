# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The weight.
      Weight = Structure.new do
        # @return [Float]
        attribute(:value, Float, from: "Value")

        # @return [String]
        attribute(:unit, String, from: "Unit")
      end
    end
  end
end
