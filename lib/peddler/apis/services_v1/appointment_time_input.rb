# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # The input appointment time details.
      AppointmentTimeInput = Structure.new do
        # @return [Time] The date, time in UTC for the start time of an appointment in ISO 8601 format.
        attribute(:start_time, Time, null: false, from: "startTime")

        # @return [Integer] The duration of an appointment in minutes.
        attribute?(:duration_in_minutes, Integer, from: "durationInMinutes")
      end
    end
  end
end
