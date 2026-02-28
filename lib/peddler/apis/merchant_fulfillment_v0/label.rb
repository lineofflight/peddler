# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Data for creating a shipping label and dimensions for printing the label.
      Label = Structure.new do
        # @return [LabelDimensions]
        attribute(:dimensions, LabelDimensions, null: false, from: "Dimensions")

        # @return [FileContents]
        attribute(:file_contents, FileContents, null: false, from: "FileContents")

        # @return [String]
        attribute?(:custom_text_for_label, String, from: "CustomTextForLabel")

        # @return [String]
        attribute?(:label_format, String, from: "LabelFormat")

        # @return [String]
        attribute?(:standard_id_for_label, String, from: "StandardIdForLabel")
      end
    end
  end
end
