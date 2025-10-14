# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorTraffic
      # Describes aggregated traffic metrics for ASINs in the vendor's account.
      TrafficAggregate = Structure.new do
        # @return [Date] The end date of the aggregated data.
        attribute(:end_date, Date, from: "endDate")

        # @return [Integer] Customer views of the vendor's product detail pages.
        attribute(:glance_views, Integer, from: "glanceViews")

        # @return [Date] The start date of the aggregated data.
        attribute(:start_date, Date, from: "startDate")
      end
    end
  end
end
