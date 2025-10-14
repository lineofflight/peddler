# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module ItemSalesEventChange
      ItemSalesEventChange = Structure.new do
        # @return [String] The merchant customer ID or vendor group ID of the partner account this notification is sent
        # to.
        attribute(:account_id, String, from: "accountId")

        # @return [String] The Amazon Standard Identification Number of the product.
        attribute(:asin, String)

        # @return [String] The currency code of any monetary amounts in ISO 4217 format.
        attribute(:currency_code, String, from: "currencyCode")

        # @return [Time] The end of the date-time range of the sales data in ISO 8601 format in UTC time.
        attribute(:end_time, Time, from: "endTime")

        # @return [String] The marketplace identifier of the sales data.
        attribute(:marketplace_id, String, from: "marketplaceId")

        # @return [Float] The ordered product sales in the specified time frame. Adjustments are made for cancellations.
        attribute(:ordered_revenue, Float, from: "orderedRevenue")

        # @return [Integer] The number of units ordered by Amazon customers in the specified time frame. This number can
        # be negative if there are more cancellations than orders.
        attribute(:ordered_units, Integer, from: "orderedUnits")

        # @return [Time] The start of the date-time range of the sales data in ISO 8601 format in UTC time.
        attribute(:start_time, Time, from: "startTime")
      end
    end
  end
end
