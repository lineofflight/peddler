# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Input for fulfillment time details
      FulfillmentTime = Structure.new do
        # @return [String] The date, time in UTC of the fulfillment end time in ISO 8601 format.
        attribute?(:end_time, String, from: "endTime")

        # @return [String] The date, time in UTC of the fulfillment start time in ISO 8601 format.
        attribute?(:start_time, String, from: "startTime")
      end
    end
  end
end
