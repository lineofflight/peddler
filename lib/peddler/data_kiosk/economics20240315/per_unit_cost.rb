# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The item level per unit cost provided by seller. Fields in this type will be null if not provided by the seller.
      PerUnitCost = Structure.new do
        # @return [Amount] Cost to manufacture or acquire the product. This value is provided by the seller and is
        #   applicable to both Fulfillment by Amazon (FBA) and Merchant Fulfilled Network (MFN) products.
        attribute?(:cost_of_goods_sold, Amount, from: "costOfGoodsSold")

        # @return [FBAPerUnitCost] The item level per unit cost provided by the seller and applicable to Fulfillment by
        #   Amazon (FBA) products.
        attribute?(:fba_cost, FBAPerUnitCost, from: "fbaCost")

        # @return [MfnPerUnitCost] The item level per unit cost provided by the seller and applicable to Merchant
        #   Fulfilled Network (MFN) products.
        attribute?(:mfn_cost, MfnPerUnitCost, from: "mfnCost")

        # @return [Amount] Miscellaneous costs not related to this specific product, ex: overhead, etc.
        # This value is provided by the seller and applicable to both Fulfillment by Amazon (FBA) and Merchant Fulfilled
        #   Network (MFN) products.
        attribute?(:miscellaneous_cost, Amount, from: "miscellaneousCost")
      end
    end
  end
end
