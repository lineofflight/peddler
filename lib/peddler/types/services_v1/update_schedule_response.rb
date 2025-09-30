# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/update_schedule_record"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # Response schema for the `updateSchedule` operation.
      UpdateScheduleResponse = Structure.new do
        # @return [Array<UpdateScheduleRecord>] Contains the `UpdateScheduleRecords` for which the error/warning has
        # occurred.
        attribute?(:payload, [UpdateScheduleRecord])

        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])
      end
    end
  end
end
