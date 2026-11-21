# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module OrdersV0
      # Dates when the business is closed or open with a different time window.
      ExceptionDates = Structure.new do
        # Date when the business is closed, in [ISO 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) date
        # format.
        attribute?(:exception_date, String, from: "ExceptionDate")

        # Boolean indicating if the business is closed or open on that date.
        attribute?(:open, :boolean, from: "IsOpen")

        # Time window during the day when the business is open.
        attribute?(:open_intervals, [OpenInterval], from: "OpenIntervals")
      end
    end
  end
end
