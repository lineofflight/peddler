# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/additional_seller_input"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # An additional set of seller inputs required to purchase shipping.
      AdditionalSellerInputs = Structure.new do
        # @return [String] The name of the additional input field.
        attribute(:additional_input_field_name, String, from: "AdditionalInputFieldName")

        # @return [AdditionalSellerInput]
        attribute(:additional_seller_input, AdditionalSellerInput, from: "AdditionalSellerInput")
      end
    end
  end
end
