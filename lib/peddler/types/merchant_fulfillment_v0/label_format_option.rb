# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # The label format details and whether to include a packing slip.
      LabelFormatOption = Structure.new do
        # @return [:boolean] When true, include a packing slip with the label.
        attribute(:include_packing_slip_with_label, :boolean, from: "IncludePackingSlipWithLabel")

        # @return [String]
        attribute(:label_format, String, from: "LabelFormat")
      end
    end
  end
end
