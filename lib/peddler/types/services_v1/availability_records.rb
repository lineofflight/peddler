# frozen_string_literal: true

require "peddler/types/services_v1/availability_record"

module Peddler
  module Types
    module ServicesV1
      # List of `AvailabilityRecord`s to represent the capacity of a resource over a time range.
      class AvailabilityRecords < Array
        class << self
          def parse(array)
            return new unless array.is_a?(Array)

            new(array.map { |item| AvailabilityRecord.parse(item) })
          end
        end
      end
    end
  end
end
