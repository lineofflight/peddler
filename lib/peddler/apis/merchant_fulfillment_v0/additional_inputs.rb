# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Maps the additional seller input to the definition. The key to the map is the field name.
      AdditionalInputs = Structure.new do
        # The field name.
        attribute?(:additional_input_field_name, String, from: "AdditionalInputFieldName")

        attribute?(:seller_input_definition, SellerInputDefinition, from: "SellerInputDefinition")
      end
    end
  end
end
