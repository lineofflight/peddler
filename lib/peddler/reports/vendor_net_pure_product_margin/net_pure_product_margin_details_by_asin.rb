# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorNetPureProductMargin
      # Describes the aggregated ASIN-level net pure product margin for ASINs in the vendor's account.
      NetPureProductMarginDetailsByASIN = Structure.new do
        # @return [String] The Amazon Standard Identification Number.
        attribute(:asin, String, null: false)

        # @return [Date] The end date of the aggregated ASIN-level data.
        attribute(:end_date, Date, null: false, from: "endDate")

        # @return [Float] A measure of Amazon's profitability considering Amazon's wholesale cost and vendor-funded
        #   cooperative marketing funds: (Product Revenue – Product COGS – Vendor Funded Coop) / Product Revenue. The
        #   value is a fraction with values between 0 and 1. To represent as a percentage, multiply the value by 100.
        attribute(:net_pure_product_margin, Float, null: false, from: "netPureProductMargin")

        # @return [Date] The start date of the aggregated ASIN-level data.
        attribute(:start_date, Date, null: false, from: "startDate")
      end
    end
  end
end
