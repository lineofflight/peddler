# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The time range within which something (for example, a delivery) will occur.
      DateRange = Structure.new do
        # @return [String] The earliest point in a date range.
        attribute(:earliest, String, null: false)

        # @return [String] The latest point in a date range.
        attribute(:latest, String, null: false)
      end
    end
  end
end
