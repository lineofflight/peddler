# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # Custom text for shipping labels.
      LabelCustomization = Structure.new do
        attribute?(:custom_text_for_label, String, from: "CustomTextForLabel")

        attribute?(:standard_id_for_label, String, from: "StandardIdForLabel")
      end
    end
  end
end
