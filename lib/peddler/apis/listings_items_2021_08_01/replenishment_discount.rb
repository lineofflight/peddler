# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ListingsItems20210801
      # A replenishment discount set by the selling partner on the offer for Subscribe & Save subscriptions.
      ReplenishmentDiscount = Structure.new do
        # @return [Integer] The seller-funded Subscribe & Save discount on the offer, as a percentage (0–100). For
        #   example, `5` means 5% off; `0` means the selling partner funds no discount.
        attribute(:discount_percentage, Integer, null: false, from: "discountPercentage")
      end
    end
  end
end
