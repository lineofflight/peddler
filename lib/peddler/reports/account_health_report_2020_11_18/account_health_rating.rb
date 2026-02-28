# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module AccountHealthReport20201118
      # Seller's account health rating within a given reporting date range for 1 requested marketplace.
      AccountHealthRating = Structure.new do
        # @return [ReportingDateRange]
        attribute(:reporting_date_range, ReportingDateRange, null: false, from: "reportingDateRange")

        # @return [String] Seller's overall Account Health Rating status within a given reporting date range for 1
        #   requested marketplace. It could be GREAT or WARNED
        attribute?(:account_health_rating_status, String, from: "accountHealthRatingStatus")
      end
    end
  end
end
