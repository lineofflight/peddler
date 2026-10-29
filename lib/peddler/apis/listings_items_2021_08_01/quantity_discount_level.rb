# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # A quantity discount level, defining the discount applied when the purchase quantity meets a given threshold.
      QuantityDiscountLevel = Structure.new do
        # @return [Integer] The quantity threshold, which is the minimum purchase quantity necessary to receive the
        #   discount. The discount applies to all units when the quantity threshold is met.
        attribute(:lower_bound, Integer, null: false, from: "lowerBound")

        # @return [String] The quantity price for this quantity threshold. When `discountType` is `PERCENT`, this is the
        #   discount percentage offered on the price (for example, `5.0` means 5% off). When `discountType` is `FIXED`,
        #   this is the fixed price set in the local currency.
        attribute(:value, String, null: false)
      end
    end
  end
end
