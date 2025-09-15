# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV2
      # Date Range for query the results.
      DateRange = Structure.new do
        # @return [String] Start Date for query .
        attribute(:start_date, String, from: "startDate")

        # @return [String] end date for query.
        attribute(:end_date, String, from: "endDate")
      end
    end
  end
end
