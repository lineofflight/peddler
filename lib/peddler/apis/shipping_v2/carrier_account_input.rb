# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ShippingV2
      # Info About CarrierAccountInput
      CarrierAccountInput = Structure.new do
        # descriptionLocalizationKey value .
        attribute?(:description_localization_key, String, from: "descriptionLocalizationKey")

        # groupName value .
        attribute?(:group_name, String, from: "groupName")

        # Known values: `TEXTBOX`, `PASSWORD`.
        attribute?(:input_type, String, from: "inputType")

        # is value is Confidential .
        attribute?(:confidential, :boolean, from: "isConfidential")

        # is value is hidden .
        attribute?(:hidden, :boolean, from: "isHidden")

        # mandatory or not value .
        attribute?(:mandatory, :boolean, from: "isMandatory")

        # name value .
        attribute?(:name, String)

        attribute?(:validation_metadata, [ValidationMetadata], from: "validationMetadata")
      end
    end
  end
end
