# frozen_string_literal: true

require "peddler/types/supply_sources_2020_07_01/operating_hour"

module Peddler
  module Types
    module SupplySources20200701
      # The operating hours per day
      OperatingHoursByDay = Structure.new do
        # @return [Array<OperatingHour>]
        attribute(:monday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute(:tuesday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute(:wednesday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute(:thursday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute(:friday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute(:saturday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute(:sunday, [OperatingHour])
      end
    end
  end
end
