# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class ServicesV1
      # The time of the appointment window.
      AppointmentTime = Structure.new do
        # @return [Integer] The duration of the appointment window, in minutes.
        attribute(:duration_in_minutes, Integer, from: "durationInMinutes")

        # @return [Time] The date and time of the start of the appointment window in ISO 8601 format.
        attribute(:start_time, Time, from: "startTime")
      end
    end
  end
end
