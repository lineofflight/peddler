# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/error"
require "peddler/types/services_v1/update_schedule_record"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `updateSchedule` operation.
      UpdateScheduleResponse = Structure.new do
        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])

        # @return [Array<UpdateScheduleRecord>] Contains the `UpdateScheduleRecords` for which the error/warning has
        # occurred.
        attribute?(:payload, [UpdateScheduleRecord])
      end
    end
  end
end
