# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Date Range for query the results.
      DateRange = Structure.new do
        # @return [String] end date for query.
        attribute?(:end_date, String, from: "endDate")

        # @return [String] Start Date for query .
        attribute?(:start_date, String, from: "startDate")
      end
    end
  end
end
