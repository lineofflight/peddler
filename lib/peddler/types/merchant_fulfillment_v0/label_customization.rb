# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Custom text for shipping labels.
      LabelCustomization = Structure.new do
        # @return [String]
        attribute(:custom_text_for_label, String, from: "CustomTextForLabel")

        # @return [String]
        attribute(:standard_id_for_label, String, from: "StandardIdForLabel")
      end
    end
  end
end
