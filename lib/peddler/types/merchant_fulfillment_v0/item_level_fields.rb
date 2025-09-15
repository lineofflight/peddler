# frozen_string_literal: true

require "peddler/types/merchant_fulfillment_v0/additional_inputs"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # A list of item level fields.
      ItemLevelFields = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, from: "Asin")

        # @return [Array<AdditionalInputs>]
        attribute(:additional_inputs, [AdditionalInputs], from: "AdditionalInputs")
      end
    end
  end
end
