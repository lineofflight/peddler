# frozen_string_literal: true

require "peddler/types/shipping_v2/validation_metadata"

module Peddler
  module Types
    module ShippingV2
      # Info About CarrierAccountInput
      CarrierAccountInput = Structure.new do
        # @return [String] descriptionLocalizationKey value .
        attribute(:description_localization_key, String, from: "descriptionLocalizationKey")

        # @return [String] name value .
        attribute(:name, String)

        # @return [String] groupName value .
        attribute(:group_name, String, from: "groupName")

        # @return [String]
        attribute(:input_type, String, from: "inputType")

        # @return [:boolean] mandatory or not value .
        attribute(:is_mandatory, :boolean, from: "isMandatory")

        # @return [:boolean] is value is Confidential .
        attribute(:is_confidential, :boolean, from: "isConfidential")

        # @return [:boolean] is value is hidden .
        attribute(:is_hidden, :boolean, from: "isHidden")

        # @return [Array<ValidationMetadata>]
        attribute(:validation_metadata, [ValidationMetadata], from: "validationMetadata")
      end
    end
  end
end
