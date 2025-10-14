# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ShippingV2
      # Info About CarrierAccountInput
      CarrierAccountInput = Structure.new do
        # @return [String] descriptionLocalizationKey value .
        attribute?(:description_localization_key, String, from: "descriptionLocalizationKey")

        # @return [String] groupName value .
        attribute?(:group_name, String, from: "groupName")

        # @return [String]
        attribute?(:input_type, String, from: "inputType")

        # @return [:boolean] is value is Confidential .
        attribute?(:confidential, :boolean, from: "isConfidential")

        # @return [:boolean] is value is hidden .
        attribute?(:hidden, :boolean, from: "isHidden")

        # @return [:boolean] mandatory or not value .
        attribute?(:mandatory, :boolean, from: "isMandatory")

        # @return [String] name value .
        attribute?(:name, String)

        # @return [Array<ValidationMetadata>]
        attribute?(:validation_metadata, [ValidationMetadata], from: "validationMetadata")
      end
    end
  end
end
