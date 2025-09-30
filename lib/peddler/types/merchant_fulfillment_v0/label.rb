# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/merchant_fulfillment_v0/label_dimensions"
require "peddler/types/merchant_fulfillment_v0/file_contents"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Data for creating a shipping label and dimensions for printing the label.
      Label = Structure.new do
        # @return [String]
        attribute?(:custom_text_for_label, String, from: "CustomTextForLabel")

        # @return [LabelDimensions]
        attribute(:dimensions, LabelDimensions, from: "Dimensions")

        # @return [FileContents]
        attribute(:file_contents, FileContents, from: "FileContents")

        # @return [String]
        attribute?(:label_format, String, from: "LabelFormat")

        # @return [String]
        attribute?(:standard_id_for_label, String, from: "StandardIdForLabel")
      end
    end
  end
end
