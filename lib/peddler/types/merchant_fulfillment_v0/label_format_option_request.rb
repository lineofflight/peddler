# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module MerchantFulfillmentV0
      # Whether to include a packing slip.
      LabelFormatOptionRequest = Structure.new do
        # @return [:boolean] When true, include a packing slip with the label.
        attribute?(:include_packing_slip_with_label, :boolean, from: "IncludePackingSlipWithLabel")
      end
    end
  end
end
