# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ProductFeesV0
      # The total estimated fees for an item and a list of details.
      FeesEstimate = Structure.new do
        # @return [Time] The time at which the fees were estimated. This defaults to the time the request is made.
        attribute(:time_of_fees_estimation, Time, null: false, from: "TimeOfFeesEstimation")

        # @return [Array<FeeDetail>]
        attribute?(:fee_detail_list, [FeeDetail], from: "FeeDetailList")

        # @return [Money] Total estimated fees for a given item, price, and fulfillment channel.
        attribute?(:total_fees_estimate, Money, from: "TotalFeesEstimate")
      end
    end
  end
end
