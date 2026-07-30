# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class Transfers20240601
      # The time interval for calculating the payout amount.
      Period = Structure.new do
        # @return [String] The starting date for a time interval.
        attribute(:start_date, String, null: false, from: "startDate")

        # @return [String] The ending date for a time interval.
        attribute?(:end_date, String, from: "endDate")
      end
    end
  end
end
