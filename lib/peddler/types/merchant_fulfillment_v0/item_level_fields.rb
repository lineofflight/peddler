# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/additional_inputs"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of item level fields.
      ItemLevelFields = Structure.new do
        # @return [Array<AdditionalInputs>]
        attribute(:additional_inputs, [AdditionalInputs], from: "AdditionalInputs")

        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "Asin")
      end
    end
  end
end
