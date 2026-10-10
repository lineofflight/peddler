# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Further granular breakdown of the subtotal of the proceeds breakdown, only available for TAX and DISCOUNT
      # proceeds types.
      ItemProceedsDetailedBreakdown = Structure.new do
        # Specific classification of the further granular breakdown.
        #
        # **Possible values**: `ITEM`, `SHIPPING`, `GIFT_WRAP`, `COD_FEE`, `OTHER`, `DISCOUNT`
        attribute?(:subtype, String)

        # Monetary amount for the further granular breakdown.
        attribute?(:value, Money)
      end
    end
  end
end
