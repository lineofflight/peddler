# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Specifies characteristics that apply to a seller input.
      SellerInputDefinition = Structure.new do
        # @return [Array<Constraint>]
        attribute(:constraints, [Constraint], null: false, from: "Constraints")

        # @return [String] The data type of the additional input field.
        attribute(:data_type, String, null: false, from: "DataType")

        # @return [String] The display text for the additional input field.
        attribute(:input_display_text, String, null: false, from: "InputDisplayText")

        # @return [:boolean] When true, the additional input field is required.
        attribute(:required, :boolean, null: false, from: "IsRequired")

        # @return [AdditionalSellerInput]
        attribute(:stored_value, AdditionalSellerInput, null: false, from: "StoredValue")

        # @return [String] Whether the seller input applies to the item or the shipment.
        attribute?(:input_target, String, from: "InputTarget")

        # @return [Array<String>]
        attribute?(:restricted_set_values, [String], from: "RestrictedSetValues")
      end
    end
  end
end
