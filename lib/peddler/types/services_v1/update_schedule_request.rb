# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/availability_record"

module Peddler
  module Types
    module ServicesV1
      # Request schema for the `updateSchedule` operation.
      UpdateScheduleRequest = Structure.new do
        # @return [Array<AvailabilityRecord>] List of schedule objects to define the normal working hours of a resource.
        attribute(:schedules, [AvailabilityRecord])
      end
    end
  end
end
