# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SalesAndTraffic20231115
      # The sales and traffic data for the seller's account aggregated by date.
      SalesAndTrafficByDate = Structure.new do
        # @return [String] The end date of the sales and traffic data.
        attribute?(:end_date, String, from: "endDate")

        # @return [String] The marketplace identifier of the sales and traffic data.
        attribute?(:marketplace_id, String, from: "marketplaceId")

        # @return [ByDateSales] The sales data for the seller's account.
        attribute?(:sales, ByDateSales)

        # @return [String] The start date of the sales and traffic data.
        attribute?(:start_date, String, from: "startDate")

        # @return [ByDateTraffic] The traffic data for the seller's account.
        attribute?(:traffic, ByDateTraffic)
      end
    end
  end
end
