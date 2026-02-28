# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # A list of item level fields.
      ItemLevelFields = Structure.new do
        # @return [Array<AdditionalInputs>]
        attribute(:additional_inputs, [AdditionalInputs], null: false, from: "AdditionalInputs")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, null: false, from: "Asin")
      end
    end
  end
end
