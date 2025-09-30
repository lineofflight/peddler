# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/orders_v0/open_interval"

module Peddler
  module Types
    module OrdersV0
      # Dates when the business is closed or open with a different time window.
      ExceptionDates = Structure.new do
        # @return [String] Date when the business is closed, in <a
        # href='https://developer-docs.amazon.com/sp-api/docs/iso-8601'>ISO 8601</a> date format.
        attribute?(:exception_date, String, from: "ExceptionDate")

        # @return [:boolean] Boolean indicating if the business is closed or open on that date.
        attribute?(:open, :boolean, from: "IsOpen")

        # @return [Array<OpenInterval>] Time window during the day when the business is open.
        attribute?(:open_intervals, [OpenInterval], from: "OpenIntervals")
      end
    end
  end
end
