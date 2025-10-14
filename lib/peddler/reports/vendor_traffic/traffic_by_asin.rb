# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorTraffic
      # Describes aggregated ASIN-level traffic metrics for ASINs in the vendor's account.
      TrafficByASIN = Structure.new do
        # @return [String] The Amazon Standard Identification Number.
        attribute(:asin, String)

        # @return [String] The end date of the aggregated ASIN-level data.
        attribute(:end_date, String, from: "endDate")

        # @return [Integer] The number of customer views of the product detail page.
        attribute(:glance_views, Integer, from: "glanceViews")

        # @return [String] The start date of the aggregated ASIN-level data.
        attribute(:start_date, String, from: "startDate")
      end
    end
  end
end
