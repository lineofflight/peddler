# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module SellerCoupon
      # Report options specifying parameters couponStartDateFrom and couponStartDateTo.
      ReportOptions = Structure.new do
        # @return [Time] The start of a date-time range in UTC used for selecting coupons to report on. All coupons with
        #   a start date-time that falls within the range will be included.
        attribute(:coupon_start_date_from, Time, from: "couponStartDateFrom")

        # @return [Time] The end of a date-time range in UTC used for selecting coupons to report on. All coupons with a
        #   start date-time that falls within the range will be included.
        attribute(:coupon_start_date_to, Time, from: "couponStartDateTo")
      end
    end
  end
end
