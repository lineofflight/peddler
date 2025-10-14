# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # The length.
      Length = Structure.new do
        # @return [String]
        attribute?(:unit, String)

        # @return [Float] The value in units.
        attribute?(:value, Float)
      end
    end
  end
end
