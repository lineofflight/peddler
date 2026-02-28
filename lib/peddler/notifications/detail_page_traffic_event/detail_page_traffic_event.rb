# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module Notifications
    module DetailPageTrafficEvent
      DetailPageTrafficEvent = Structure.new do
        # @return [String] The merchant customer ID or vendor group ID of the partner account this notification is sent
        #   to.
        attribute(:account_id, String, null: false, from: "accountId")

        # @return [String] The Amazon Standard Identification Number of the product.
        attribute(:asin, String, null: false)

        # @return [Time] The end of the date-time range of the traffic data in ISO 8601 format in UTC time.
        attribute(:end_time, Time, null: false, from: "endTime")

        # @return [Integer] The number of customer views of the product detail page for this ASIN.
        attribute(:glance_views, Integer, null: false, from: "glanceViews")

        # @return [String] The marketplace identifier of the traffic data.
        attribute(:marketplace_id, String, null: false, from: "marketplaceId")

        # @return [Time] The start of the date-time range of the traffic data in ISO 8601 format in UTC time.
        attribute(:start_time, Time, null: false, from: "startTime")
      end
    end
  end
end
