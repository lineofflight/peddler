# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Return-defect metrics at the individual defect-topic level.
      ReturnDefectTopicMetrics = Structure.new do
        # @return [FloatWithBenchmarking] Fraction (between 0 and 1) of the product's total return defects attributed to
        #   this defect topic. Not supported under totals.
        attribute?(:return_defect_contribution, FloatWithBenchmarking, from: "returnDefectContribution")

        # @return [IntWithBenchmarking] Number of return defects reported for this defect topic (trailing six months).
        #   Not supported under totals.
        attribute?(:return_defect_frequency, IntWithBenchmarking, from: "returnDefectFrequency")

        # @return [String] Recommended actions to address the return defects associated with this topic. Not supported
        #   under totals.
        attribute?(:return_defect_recommendations, String, from: "returnDefectRecommendations")

        # @return [String] Return-defect topic categorizing customer-reported product defects.
        # This field automatically groups results when selected, showing metrics per unique defect topic. Not supported
        #   under totals.
        attribute?(:return_defect_topic, String, from: "returnDefectTopic")
      end
    end
  end
end
