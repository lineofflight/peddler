# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # The weight.
      Weight = Structure.new do
        # Known values: `oz`, `g`.
        attribute(:unit, String, null: false, from: "Unit")

        attribute(:value, Float, null: false, from: "Value")
      end
    end
  end
end
