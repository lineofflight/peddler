# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      # The sales and traffic data for the seller's account aggregated by date.
      SalesAndTrafficByDate = Structure.new do
        # @return [String] The end date of the sales and traffic data.
        attribute?(:end_date, String, null: false, from: "endDate")

        # @return [String] The marketplace identifier of the sales and traffic data.
        attribute?(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [ByDateSales] The sales data for the seller's account.
        attribute?(:sales, ByDateSales, null: false)

        # @return [String] The start date of the sales and traffic data.
        attribute?(:start_date, String, null: false, from: "startDate")

        # @return [ByDateTraffic] The traffic data for the seller's account.
        attribute?(:traffic, ByDateTraffic, null: false)
      end
    end
  end
end
