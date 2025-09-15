# frozen_string_literal: true

require "peddler/types/easy_ship_2022_03_23/scheduled_package_id"
require "peddler/types/easy_ship_2022_03_23/time_slot"

module Peddler
  module Types
    module EasyShip20220323
      # Request to update the time slot of a package.
      UpdatePackageDetails = Structure.new do
        # @return [ScheduledPackageId]
        attribute(:scheduled_package_id, ScheduledPackageId, from: "scheduledPackageId")

        # @return [TimeSlot]
        attribute(:package_time_slot, TimeSlot, from: "packageTimeSlot")
      end
    end
  end
end
