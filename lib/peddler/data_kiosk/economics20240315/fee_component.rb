# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module Economics20240315
      # The fee component data applied to a given product in the seller's account within a given date range. It's
      # breakdown of parent fee.
      FeeComponent = Structure.new do
        # @return [AggregatedDetail] Fee component aggregated detail.
        attribute?(:aggregated_detail, AggregatedDetail, null: false, from: "aggregatedDetail")

        # @return [String] Fee component name, for example: "Base fulfillment fee".
        attribute?(:name, String, null: false)

        # @return [Array<EconomicsProperty>] The properties used to calculate the 'aggregatedDetail' value in
        #   'FeeComponent'. Example: Product Size Tier, an important property that determines the amountPerUnit of
        #   FBA_FULFILLMENT_FEE component.
        attribute?(:properties, [EconomicsProperty])
      end
    end
  end
end
