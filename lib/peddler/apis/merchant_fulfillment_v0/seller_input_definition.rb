# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Specifies characteristics that apply to a seller input.
      SellerInputDefinition = Structure.new do
        attribute(:constraints, [Constraint], null: false, from: "Constraints")

        # The data type of the additional input field.
        attribute(:data_type, String, null: false, from: "DataType")

        # The display text for the additional input field.
        attribute(:input_display_text, String, null: false, from: "InputDisplayText")

        # When true, the additional input field is required.
        attribute(:required, :boolean, null: false, from: "IsRequired")

        attribute(:stored_value, AdditionalSellerInput, null: false, from: "StoredValue")

        # Whether the seller input applies to the item or the shipment. Known values: `SHIPMENT_LEVEL`, `ITEM_LEVEL`.
        attribute?(:input_target, String, from: "InputTarget")

        attribute?(:restricted_set_values, [String], from: "RestrictedSetValues")
      end
    end
  end
end
