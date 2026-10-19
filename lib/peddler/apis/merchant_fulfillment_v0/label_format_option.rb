# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module MerchantFulfillmentV0
      # The label format details and whether to include a packing slip.
      LabelFormatOption = Structure.new do
        # When true, include a packing slip with the label.
        attribute?(:include_packing_slip_with_label, :boolean, from: "IncludePackingSlipWithLabel")

        # Known values: `PDF`, `PNG`, `ZPL203`, `ZPL300`, `ShippingServiceDefault`.
        attribute?(:label_format, String, from: "LabelFormat")
      end
    end
  end
end
