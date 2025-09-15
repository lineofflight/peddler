# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ShippingV1
      # The time range.
      TimeRange = Structure.new do
        # @return [String] The start date and time. This defaults to the current date and time.
        attribute(:start, String)

        # @return [String] The end date and time. This must come after the value of start. This defaults to the next
        # business day from the start.
        attribute(:end, String)
      end
    end
  end
end
