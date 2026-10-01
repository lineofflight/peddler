# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Defects metric group for return-defect analytics. A null value for a given metric means that this metric is not
      # yet available.
      Defects = Structure.new do
        # @return [Array<ReturnDefectTopicMetrics>] Return-defect metrics grouped by defect topic.
        # Returns an array of metrics per unique return-defect topic within the current grouping context.
        attribute?(:topics, [ReturnDefectTopicMetrics])

        # @return [IntWithBenchmarking] Total frequency of return defects across all topics for the product (trailing
        #   six months). Not supported under totals.
        attribute?(:total_defect_frequency, IntWithBenchmarking, from: "totalDefectFrequency")
      end
    end
  end
end
