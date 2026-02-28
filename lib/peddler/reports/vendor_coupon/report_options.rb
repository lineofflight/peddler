# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorCoupon
      # Report options specifying parameters campaignStartDateFrom and campaignStartDateTo.
      ReportOptions = Structure.new do
        # @return [Time] The start of a date-time range in UTC used for selecting coupons to report on. All coupons with
        #   a start date-time that falls within the range will be included.
        attribute(:campaign_start_date_from, Time, null: false, from: "campaignStartDateFrom")

        # @return [Time] The end of a date-time range in UTC used for selecting coupons to report on. All coupons with a
        #   start date-time that falls within the range will be included.
        attribute(:campaign_start_date_to, Time, null: false, from: "campaignStartDateTo")
      end
    end
  end
end
