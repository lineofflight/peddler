# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The length.
      Length = Structure.new do
        # @return [Float] The value in units.
        attribute(:value, Float)

        # @return [String]
        attribute(:unit, String)
      end
    end
  end
end
