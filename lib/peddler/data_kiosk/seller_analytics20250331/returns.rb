# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module DataKiosk
    module SellerAnalytics20250331
      # Returns metric group. A null value for a given metric means that this metric is not yet available.
      Returns = Structure.new do
        # @return [FloatWithBenchmarking] Rate of returned units relative to shipped units for the selected time period,
        #   as a fraction between 0 and 1 (returned units / shipped units). Return data is computed with a delay of
        #   about 45 days, so the rate may appear low for recent dates. Not supported under totals.
        attribute?(:returned_rate, FloatWithBenchmarking, from: "returnedRate")

        # @return [IntWithBenchmarking] Number of units returned by customers with a resolution (refund or replacement),
        #   including returnless refunds, mapped to the day each unit was shipped.
        # Return data is computed with a delay of about 45 days, so the most recent ~45 days may be empty or incomplete.
        attribute?(:returned_units, IntWithBenchmarking, from: "returnedUnits")

        # @return [AmountWithBenchmarking] Total amount refunded to customers in the selected time period, including all
        #   refunds, in the currency specified by the currencyCode argument (USD if not provided). Refund data is
        #   computed with a delay of about 45 days, so the most recent ~45 days may be empty or incomplete.
        attribute?(:total_refund_amount, AmountWithBenchmarking, from: "totalRefundAmount")
      end
    end
  end
end
