# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Data for creating a shipping label and dimensions for printing the label.
      Label = Structure.new do
        attribute(:dimensions, LabelDimensions, null: false, from: "Dimensions")

        attribute(:file_contents, FileContents, null: false, from: "FileContents")

        attribute?(:custom_text_for_label, String, from: "CustomTextForLabel")

        attribute?(:label_format, String, from: "LabelFormat")

        attribute?(:standard_id_for_label, String, from: "StandardIdForLabel")
      end
    end
  end
end
