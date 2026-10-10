# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module DataKiosk
    module SalesAndTraffic20240424
      # The sales and traffic data for the seller's account aggregated by date.
      SalesAndTrafficByDate = Structure.new do
        # The end date of the sales and traffic data.
        attribute?(:end_date, String, null: false, from: "endDate")

        # The marketplace identifier of the sales and traffic data.
        attribute?(:marketplace_id, String, null: false, from: "marketplaceId")

        # The sales data for the seller's account.
        attribute?(:sales, ByDateSales, null: false)

        # The start date of the sales and traffic data.
        attribute?(:start_date, String, null: false, from: "startDate")

        # The traffic data for the seller's account.
        attribute?(:traffic, ByDateTraffic, null: false)
      end
    end
  end
end
