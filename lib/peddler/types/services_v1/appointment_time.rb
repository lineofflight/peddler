# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module ServicesV1
      # The time of the appointment window.
      AppointmentTime = Structure.new do
        # @return [String] The date and time of the start of the appointment window in ISO 8601 format.
        attribute(:start_time, String, from: "startTime")

        # @return [Integer] The duration of the appointment window, in minutes.
        attribute(:duration_in_minutes, Integer, from: "durationInMinutes")
      end
    end
  end
end
