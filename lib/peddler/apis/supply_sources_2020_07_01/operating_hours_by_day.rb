# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module SupplySources20200701
      # The operating hours per day
      OperatingHoursByDay = Structure.new do
        attribute?(:friday, [OperatingHour])

        attribute?(:monday, [OperatingHour])

        attribute?(:saturday, [OperatingHour])

        attribute?(:sunday, [OperatingHour])

        attribute?(:thursday, [OperatingHour])

        attribute?(:tuesday, [OperatingHour])

        attribute?(:wednesday, [OperatingHour])
      end
    end
  end
end
