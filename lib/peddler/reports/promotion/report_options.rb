# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module Promotion
      # Report options specifying the parameters promotionStartDateFrom and promotionStartDateTo.
      ReportOptions = Structure.new do
        # @return [Time] The start of a date and time range in ISO 8601 format used for selecting promotions to report
        # on. All promotions with a start date-time that falls within the range will be included.
        attribute(:promotion_start_date_from, Time, from: "promotionStartDateFrom")

        # @return [Time] The end of a date and time range in ISO 8601 format used for selecting promotions to report on.
        # All promotions with a start date-time that falls within the range will be included.
        attribute(:promotion_start_date_to, Time, from: "promotionStartDateTo")
      end
    end
  end
end
