# frozen_string_literal: true

# This file is generated. Edit template if necessary.

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
