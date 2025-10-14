# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module SellerCoupon
      # This report contains data to help sellers optimize their coupons and adjust their advertising strategies. This
      # report supports start dates up to two years before the current date.
      Report = Structure.new do
        # @return [Array<CouponDetails>] A list of included coupons.
        attribute(:coupons, [CouponDetails])

        # @return [Hash] Summarizes the original report request.
        attribute(:report_specification, ReportSpecification, from: "reportSpecification")
      end
    end
  end
end
