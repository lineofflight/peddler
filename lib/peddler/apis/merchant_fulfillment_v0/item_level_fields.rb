# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # A list of item level fields.
      ItemLevelFields = Structure.new do
        attribute(:additional_inputs, [AdditionalInputs], null: false, from: "AdditionalInputs")

        # The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, null: false, from: "Asin")
      end
    end
  end
end
