# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module Orders20260101
      # Detailed proceeds breakdown for a specific order item.
      ItemProceedsBreakdown = Structure.new do
        # Monetary amount for the proceeds breakdown.
        attribute(:subtotal, Money, null: false)

        # Category classification of the proceeds breakdown.
        #
        # **Possible values**: `ITEM`, `SHIPPING`, `GIFT_WRAP`, `COD_FEE`, `OTHER`, `TAX`, `DISCOUNT`
        attribute(:type, String, null: false)

        # Further granular breakdown of the subtotal.
        attribute?(:detailed_breakdowns, [ItemProceedsDetailedBreakdown], from: "detailedBreakdowns")
      end
    end
  end
end
