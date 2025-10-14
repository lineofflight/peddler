# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class SupplySources20200701
      # The operating hours per day
      OperatingHoursByDay = Structure.new do
        # @return [Array<OperatingHour>]
        attribute?(:friday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute?(:monday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute?(:saturday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute?(:sunday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute?(:thursday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute?(:tuesday, [OperatingHour])

        # @return [Array<OperatingHour>]
        attribute?(:wednesday, [OperatingHour])
      end
    end
  end
end
