# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/merchant_fulfillment_v0/constraint"
require "peddler/types/merchant_fulfillment_v0/additional_seller_input"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Specifies characteristics that apply to a seller input.
      SellerInputDefinition = Structure.new do
        # @return [Array<Constraint>]
        attribute(:constraints, [Constraint], from: "Constraints")

        # @return [String] The data type of the additional input field.
        attribute(:data_type, String, from: "DataType")

        # @return [String] The display text for the additional input field.
        attribute(:input_display_text, String, from: "InputDisplayText")

        # @return [:boolean] When true, the additional input field is required.
        attribute(:required, :boolean, from: "IsRequired")

        # @return [AdditionalSellerInput]
        attribute(:stored_value, AdditionalSellerInput, from: "StoredValue")

        # @return [String] Whether the seller input applies to the item or the shipment.
        attribute?(:input_target, String, from: "InputTarget")

        # @return [Array<String>]
        attribute?(:restricted_set_values, [String], from: "RestrictedSetValues")
      end
    end
  end
end
