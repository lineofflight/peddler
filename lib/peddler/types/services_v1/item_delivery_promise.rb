# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Promised delivery information for the item.
      ItemDeliveryPromise = Structure.new do
        # @return [String] The date and time of the end of the promised delivery window in ISO 8601 format.
        attribute?(:end_time, String, from: "endTime")

        # @return [String] The date and time of the start of the promised delivery window in ISO 8601 format.
        attribute?(:start_time, String, from: "startTime")
      end
    end
  end
end
