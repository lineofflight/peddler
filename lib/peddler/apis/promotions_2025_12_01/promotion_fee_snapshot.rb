# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Promotions20251201
      # The promotion's fee information (rates and incentive programs) that was locked at the time of promotion
      # creation. You can estimate promotion fees (fee preview) at time t1, while promotion creation can happen at time
      # t2. This object includes the fee information captured at time t2. If empty, it means that no fee information was
      # recorded, which indicates that either a promotion type or a marketplace does not currently support promotion
      # fees.
      PromotionFeeSnapshot = Structure.new do
        # @return [PreviewedFeeRates]
        attribute?(:previewed_fee_rates, PreviewedFeeRates, from: "previewedFeeRates")
      end
    end
  end
end
