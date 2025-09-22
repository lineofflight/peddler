# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The start and end time that specifies the time interval of an event.
      TimeWindow = Structure.new do
        # @return [String] The start time of the time window.
        attribute(:start, String)

        # @return [String] The end time of the time window.
        attribute(:end, String)
      end
    end
  end
end
