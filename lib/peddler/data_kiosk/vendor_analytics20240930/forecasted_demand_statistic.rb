# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module VendorAnalytics20240930
      # Amazon's estimate that customer demand will be at or below this value.
      ForecastedDemandStatistic = Structure.new do
        # @return [String] Amazon’s best estimate of weekly customer demand (in units). This estimate does not account
        # for safety stock.
        attribute?(:mean, String)

        # @return [String] Amazon estimates that there is a 70% probability that customer demand will be at or below
        # this number of units.
        attribute?(:p70, String)

        # @return [String] Amazon estimates that there is a 80% probability that customer demand will be at or below
        # this number of units.
        attribute?(:p80, String)

        # @return [String] Amazon estimates that there is a 90% probability that customer demand will be at or below
        # this number of units.
        attribute?(:p90, String)
      end
    end
  end
end
