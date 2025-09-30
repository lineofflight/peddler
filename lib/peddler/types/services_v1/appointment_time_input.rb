# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module ServicesV1
      # The input appointment time details.
      AppointmentTimeInput = Structure.new do
        # @return [String] The date, time in UTC for the start time of an appointment in ISO 8601 format.
        attribute(:start_time, String, from: "startTime")

        # @return [Integer] The duration of an appointment in minutes.
        attribute?(:duration_in_minutes, Integer, from: "durationInMinutes")
      end
    end
  end
end
