# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module CustomerFeedback20240601
      # A date range.
      DateRange = Structure.new do
        # @return [String] The end date of the date range in ISO-8601 date/time format.
        attribute(:end_date, String, from: "endDate")

        # @return [String] The start date of the date range in ISO-8601 date/time format.
        attribute(:start_date, String, from: "startDate")
      end
    end
  end
end
