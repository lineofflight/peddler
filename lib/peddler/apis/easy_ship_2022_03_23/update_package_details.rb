# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class EasyShip20220323
      # Request to update the time slot of a package.
      UpdatePackageDetails = Structure.new do
        # @return [TimeSlot]
        attribute(:package_time_slot, TimeSlot, from: "packageTimeSlot")

        # @return [ScheduledPackageId]
        attribute(:scheduled_package_id, ScheduledPackageId, from: "scheduledPackageId")
      end
    end
  end
end
