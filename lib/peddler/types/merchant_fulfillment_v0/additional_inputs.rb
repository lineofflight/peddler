# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/seller_input_definition"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Maps the additional seller input to the definition. The key to the map is the field name.
      AdditionalInputs = Structure.new do
        # @return [String] The field name.
        attribute?(:additional_input_field_name, String, from: "AdditionalInputFieldName")

        # @return [SellerInputDefinition]
        attribute?(:seller_input_definition, SellerInputDefinition, from: "SellerInputDefinition")
      end
    end
  end
end
