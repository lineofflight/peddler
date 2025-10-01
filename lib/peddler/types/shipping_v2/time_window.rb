# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ShippingV2
      # The start and end time that specifies the time interval of an event.
      TimeWindow = Structure.new do
        # @return [String] The end time of the time window.
        attribute?(:end, String)

        # @return [String] The start time of the time window.
        attribute?(:start, String)
      end
    end
  end
end
