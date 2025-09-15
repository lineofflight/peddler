# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ServicesV1
      # Promised delivery information for the item.
      ItemDeliveryPromise = Structure.new do
        # @return [String] The date and time of the start of the promised delivery window in ISO 8601 format.
        attribute(:start_time, String, from: "startTime")

        # @return [String] The date and time of the end of the promised delivery window in ISO 8601 format.
        attribute(:end_time, String, from: "endTime")
      end
    end
  end
end
