# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # The length.
      Length = Structure.new do
        # Known values: `inches`, `centimeters`.
        attribute?(:unit, String)

        # The value in units.
        attribute?(:value, Float)
      end
    end
  end
end
