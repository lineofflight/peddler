# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FeePromotion
      FeesEstimate = Structure.new do
        # @return [Array]
        attribute(:fee_details, Array, null: false, from: "FeeDetails")

        # @return [String]
        attribute(:time_of_fees_estimated, String, null: false, from: "TimeOfFeesEstimated")

        # @return [Hash]
        attribute(:total_fees_estimate, Hash, null: false, from: "TotalFeesEstimate")
      end
    end
  end
end
