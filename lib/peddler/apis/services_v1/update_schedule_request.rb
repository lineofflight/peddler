# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Request schema for the `updateSchedule` operation.
      UpdateScheduleRequest = Structure.new do
        # @return [Array<AvailabilityRecord>] List of schedule objects to define the normal working hours of a resource.
        attribute(:schedules, [AvailabilityRecord], null: false)
      end
    end
  end
end
