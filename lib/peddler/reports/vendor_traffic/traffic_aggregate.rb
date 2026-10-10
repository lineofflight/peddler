# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Reports
    module VendorTraffic
      # Describes aggregated traffic metrics for ASINs in the vendor's account.
      TrafficAggregate = Structure.new do
        # The end date of the aggregated data.
        attribute(:end_date, Date, null: false, from: "endDate")

        # Customer views of the vendor's product detail pages.
        attribute(:glance_views, Integer, null: false, from: "glanceViews")

        # The start date of the aggregated data.
        attribute(:start_date, Date, null: false, from: "startDate")
      end
    end
  end
end
