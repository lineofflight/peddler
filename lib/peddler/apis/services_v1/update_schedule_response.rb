# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ServicesV1
      # Response schema for the `updateSchedule` operation.
      UpdateScheduleResponse = Structure.new do
        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])

        # @return [Array<UpdateScheduleRecord>] Contains the `UpdateScheduleRecords` for which the error/warning has
        #   occurred.
        attribute?(:payload, [UpdateScheduleRecord])
      end
    end
  end
end
