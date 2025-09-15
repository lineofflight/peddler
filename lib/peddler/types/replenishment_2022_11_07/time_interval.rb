# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module Replenishment20221107
      # A date-time interval in ISO 8601 format which is used to compute metrics. Only the date is required, but you
      # must pass the complete date and time value. For example, November 11, 2022 should be passed as
      # "2022-11-07T00:00:00Z". Note that only data for the trailing 2 years is supported.
      #
      # **Note**: The `listOfferMetrics` operation only supports a time interval which covers a single unit of the
      # aggregation frequency. For example, for a MONTH aggregation frequency, the duration of the interval between the
      # startDate and endDate can not be more than 1 month.
      TimeInterval = Structure.new do
        # @return [String] When this object is used as a request parameter, the specified `startDate` is adjusted based
        # on the aggregation frequency.
        #
        # * For `WEEK` the metric is computed from the first day of the week (Sunday, based on ISO 8601) that contains
        # the `startDate`.
        # * For `MONTH` the metric is computed from the first day of the month that contains the `startDate`.
        # * For `QUARTER` the metric is computed from the first day of the quarter that contains the `startDate`.
        # * For `YEAR` the metric is computed from the first day of the year that contains the `startDate`.
        attribute(:start_date, String, from: "startDate")

        # @return [String] When this object is used as a request parameter, the specified `endDate` is adjusted based on
        # the aggregation frequency.
        #
        # * For `WEEK` the metric is computed up to the last day of the week (Sunday, based on ISO 8601) that contains
        # the `endDate`.
        # * For `MONTH`, the metric is computed up to the last day that contains the `endDate`.
        # * For `QUARTER` the metric is computed up to the last day of the quarter that contains the `endDate`.
        # * For `YEAR` the metric is computed up to the last day of the year that contains the `endDate`.
        # Note: The end date may be adjusted to a lower value based on the data available in our system.
        attribute(:end_date, String, from: "endDate")
      end
    end
  end
end
