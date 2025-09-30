# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # A time window along with associated capacity in which the service can be performed.
      AppointmentSlot = Structure.new do
        # @return [String] Time window start time in ISO 8601 format.
        attribute?(:start_time, String, from: "startTime")

        # @return [String] Time window end time in ISO 8601 format.
        attribute?(:end_time, String, from: "endTime")

        # @return [Integer] Number of resources for which a slot can be reserved.
        attribute?(:capacity, Integer)
      end
    end
  end
end
