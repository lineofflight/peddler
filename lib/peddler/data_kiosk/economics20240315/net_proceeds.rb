# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The net proceeds for a given product in the seller's account for a given time range. These fields are calculated
      # as sales.netProductSales - sum of fees.charge.totalAmount - sum of ads.charge.totalAmount - (cost of Merchant
      # Fulfilled Network (MFN) products or cost of Fulfillment by Amazon (FBA) products) * sales.netUnitsSold.
      NetProceeds = Structure.new do
        # @return [Amount] Net proceeds per unit for a given product in the seller's account for a given time range.
        #   This value is calculated by dividing total by sales.netUnitsSold.
        attribute?(:per_unit, Amount, from: "perUnit")

        # @return [Amount] "Total net proceeds for a given product in the seller's account for a given time range.
        attribute?(:total, Amount)
      end
    end
  end
end
