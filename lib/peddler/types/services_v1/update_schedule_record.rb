# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/services_v1/availability_record"
require "peddler/types/services_v1/error"
require "peddler/types/services_v1/warning"

module Peddler
  module Types
    module ServicesV1
      # `UpdateScheduleRecord` entity contains the `AvailabilityRecord` if there is an error/warning while performing
      # the requested operation on it.
      UpdateScheduleRecord = Structure.new do
        # @return [AvailabilityRecord] Availability record if the operation failed.
        attribute?(:availability, AvailabilityRecord)

        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])

        # @return [Array<Warning>] Warnings encountered, if any.
        attribute?(:warnings, [Warning])
      end
    end
  end
end
