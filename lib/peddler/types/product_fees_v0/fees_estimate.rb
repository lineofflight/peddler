# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/money"
require "peddler/types/product_fees_v0/fee_detail"

module Peddler
  module Types
    module ProductFeesV0
      # The total estimated fees for an item and a list of details.
      FeesEstimate = Structure.new do
        # @return [String] The time at which the fees were estimated. This defaults to the time the request is made.
        attribute(:time_of_fees_estimation, String, from: "TimeOfFeesEstimation")

        # @return [Types::Money] Total estimated fees for a given item, price, and fulfillment channel.
        attribute(:total_fees_estimate, Types::Money, from: "TotalFeesEstimate")

        # @return [Array<FeeDetail>]
        attribute(:fee_detail_list, [FeeDetail], from: "FeeDetailList")
      end
    end
  end
end
