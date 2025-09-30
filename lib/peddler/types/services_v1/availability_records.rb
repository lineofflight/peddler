# frozen_string_literal: true

require "peddler/types/services_v1/availability_record"

# This file is generated. Edit template if necessary.

module Peddler
  module Types
    module ServicesV1
      # List of `AvailabilityRecord`s to represent the capacity of a resource over a time range.
      class AvailabilityRecords < Array
        class << self
          def parse(array)
            new(array.map { |item| AvailabilityRecord.parse(item) })
          end
        end
      end
    end
  end
end
