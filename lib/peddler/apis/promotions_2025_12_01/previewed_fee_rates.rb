# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # Fee rates that were previewed to the selling partner. Example fee rates are `$100` or `5% of sales`.
      PreviewedFeeRates = Structure.new do
        # @return [UpfrontFee]
        attribute?(:upfront_fee, UpfrontFee, from: "upfrontFee")

        # @return [VariableFee]
        attribute?(:variable_fee, VariableFee, from: "variableFee")
      end
    end
  end
end
