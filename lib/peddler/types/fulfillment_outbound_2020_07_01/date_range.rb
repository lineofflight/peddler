# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The time range within which something (for example, a delivery) will occur.
      DateRange = Structure.new do
        # @return [String] The earliest point in a date range.
        attribute(:earliest, String)

        # @return [String] The latest point in a date range.
        attribute(:latest, String)
      end
    end
  end
end
