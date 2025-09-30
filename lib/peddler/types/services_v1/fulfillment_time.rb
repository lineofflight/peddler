# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Input for fulfillment time details
      FulfillmentTime = Structure.new do
        # @return [String] The date, time in UTC of the fulfillment start time in ISO 8601 format.
        attribute?(:start_time, String, from: "startTime")

        # @return [String] The date, time in UTC of the fulfillment end time in ISO 8601 format.
        attribute?(:end_time, String, from: "endTime")
      end
    end
  end
end
