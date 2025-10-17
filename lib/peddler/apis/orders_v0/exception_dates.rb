# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class OrdersV0
      # Dates when the business is closed or open with a different time window.
      ExceptionDates = Structure.new do
        # @return [String] Date when the business is closed, in {https://developer-docs.amazon.com/sp-api/docs/iso-8601
        #   ISO 8601} date format.
        attribute?(:exception_date, String, from: "ExceptionDate")

        # @return [:boolean] Boolean indicating if the business is closed or open on that date.
        attribute?(:open, :boolean, from: "IsOpen")

        # @return [Array<OpenInterval>] Time window during the day when the business is open.
        attribute?(:open_intervals, [OpenInterval], from: "OpenIntervals")
      end
    end
  end
end
