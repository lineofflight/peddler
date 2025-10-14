# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class MerchantFulfillmentV0
      # Whether to include a packing slip.
      LabelFormatOptionRequest = Structure.new do
        # @return [:boolean] When true, include a packing slip with the label.
        attribute?(:include_packing_slip_with_label, :boolean, from: "IncludePackingSlipWithLabel")
      end
    end
  end
end
