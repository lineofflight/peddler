# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/services_v1/availability_record"
require "peddler/types/services_v1/warning"
require "peddler/types/services_v1/error"

module Peddler
  module Types
    module ServicesV1
      # `UpdateScheduleRecord` entity contains the `AvailabilityRecord` if there is an error/warning while performing
      # the requested operation on it.
      UpdateScheduleRecord = Structure.new do
        # @return [AvailabilityRecord] Availability record if the operation failed.
        attribute?(:availability, AvailabilityRecord)

        # @return [Array<Warning>] Warnings encountered, if any.
        attribute?(:warnings, [Warning])

        # @return [Array<Error>] Errors encountered, if any.
        attribute?(:errors, [Error])
      end
    end
  end
end
